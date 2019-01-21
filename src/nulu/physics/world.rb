require 'set'

module Nulu
  class World

    # Known Simulation Issues
    # - In scenarios involving collision of more than 2 objects at a time, (example:
    #   object falling on object standing on the floor), the iterations needed for a
    #   proper response provokes a significant slowdown.
    # - Not necesarily a problem, but multiple objects pushing one another get
    #   correctly resolved iteratively, not exactly
    # - When objects push each other, they jitter: Friction is applied inmediatly
    #   upon object collision. In the current scheme of collision resolving, this
    #   makes for 'non-deterministic' behaviour: the overall result depends on which
    #   collisions are solved first (example: upon A and B colliding: A colliding
    #   with floor, then A and B colliding, then B colliding with floor; results
    #   in A and B colliding, but having different velocities).
    # - The logic separating objects from overlapping is not very robust, so if
    #   objects squish one another against, say, a wall, they'll begin to overlap.
    #   This may break the engine if the velocities are high enough, and the walls
    #   thin enough.
    ##

    COLLISION_LOOP_TRIES = 100

    def initialize()
      @body_pool = {}
      @current_id = 0
      @collision_enabler = CollisionEnabler.new()
      @collision_skip = Set.new()
      @normals = {}
    end

    def make_body(shape, mass, friction = 0.0, group = :nulu_world_default)
      free_body = FreeBody.new(shape, mass, friction)
      return add_and_return_restricted_body_for(free_body, group)
    end

    def make_static_body(shape, friction = 0.0, group = :nulu_world_default)
      free_body = FreeBody.new(shape, INF, friction)
      free_body.gravityless = true
      return add_and_return_restricted_body_for(free_body, group)
    end


    def disable_collision_within(group)
      @collision_enabler.disable_collision_within(group)
    end

    def disable_collision_between(group_a, group_b)
      @collision_enabler.disable_collision_between(group_a, group_b)
    end

    def enable_collision_within(group)
      @collision_enabler.enable_collision_within(group)
    end

    def enable_collision_between(group_a, group_b)
      @collision_enabler.enable_collision_between(group_a, group_b)
    end

    def disable_collision_between_bodies(a, b)
      @collision_skip.add(SortedPair.new(a.id,b.id))
    end

    def renable_collision_between_bodies(a, b)
      @collision_skip.delete(SortedPair.new(a.id,b.id))
    end


    def get_body_normal(id)
      return @normals[id]
    end


    def update(delta)
      
      # Gravity
      @body_pool.each do |id, body|
        next if body.gravityless
        body.velocity.y -= 4
      end

      # Initialize normals
      @normals.clear()
      @body_pool.each do |id, body|
        @normals[id] = Nulu::Vector.new(0, 0)
      end

      # Main loop
      tries = COLLISION_LOOP_TRIES
      time_left = delta

      while time_left >= 1e-3 && tries >= 0

        # Defensive separation
        separate_bodies()

        # Find earliest collision
        earliest_collision_time = nil
        earliest_collision_normal = nil
        earliest_collision_body_a = nil
        earliest_collision_body_b = nil
        earliest_collision_body_id_a = nil
        earliest_collision_body_id_b = nil

        each_collidable_bodies do |id_a, a, id_b, b|
          collision_time, collision_normal = Collision::get_collision_time_and_normal(a.shape, a.velocity, b.shape, b.velocity)
          if collision_time && collision_time <= time_left
            # there will be collision
            if !earliest_collision_time || collision_time <= earliest_collision_time
              # earliest collision update
              earliest_collision_time = collision_time
              earliest_collision_normal = collision_normal
              earliest_collision_body_a = a
              earliest_collision_body_b = b
              earliest_collision_body_id_a = id_a
              earliest_collision_body_id_b = id_b
            end
          end
        end

        # Goto earliest collision
        if earliest_collision_time
          elapsed_time = earliest_collision_time * 0.999
        else 
          elapsed_time = time_left
        end

        @body_pool.each do |id, body|
          body.move(body.velocity * elapsed_time)
        end

        # Collision Response
        if earliest_collision_time && earliest_collision_normal

          # Renaming
          a = earliest_collision_body_a
          b = earliest_collision_body_b
          id_a = earliest_collision_body_id_a
          id_b = earliest_collision_body_id_b

          # Decomposition
          a_velocity_into_plane, a_velocity_along_plane = a.velocity.decompose_into(earliest_collision_normal)
          b_velocity_into_plane, b_velocity_along_plane = b.velocity.decompose_into(earliest_collision_normal)

          # Velocity into plane
          a_mass_ratio = get_ratio(a.mass, b.mass)
          new_velocity_into_plane = a_velocity_into_plane * a_mass_ratio + b_velocity_into_plane * (1.0 - a_mass_ratio)

          # Velocity along plane (friction)
          velocity_keep = a.frictionless || b.frictionless ? 1.0 : (1.0 - a.friction) * (1.0 - b.friction)
          a_new_velocity_along_plane = a_velocity_along_plane * velocity_keep
          b_new_velocity_along_plane = b_velocity_along_plane * velocity_keep

          # Apply velocity
          a.velocity = a_new_velocity_along_plane + new_velocity_into_plane
          b.velocity = b_new_velocity_along_plane + new_velocity_into_plane

          # Normal calculation
          @normals[id_a] += new_velocity_into_plane - a_velocity_into_plane
          @normals[id_b] += new_velocity_into_plane - b_velocity_into_plane
        end

        # Advance cycle
        time_left -= elapsed_time
        tries-= 1
      end

      # If there's still time left, we ignore collisions and just attempt to finish the update
      @body_pool.each do |id, body|
        body.move(body.velocity * time_left)
      end
      separate_bodies()

    end


    private

    def separate_bodies()
      each_collidable_bodies do |id_a, a, id_b, b|
        if Nulu::Collision.colliding?(a.shape, b.shape)
          mtv = Nulu::Collision.mtv(a.shape, b.shape)
          a_mass_ratio = get_ratio(a.mass, b.mass)
          b.move(mtv * a_mass_ratio)
          a.move(-mtv * (1.0 - a_mass_ratio))
        end
      end
    end

    def each_collidable_bodies()
      @collision_enabler.each_collidable_pair do |pa, pb|
        if !@collision_skip.include?(SortedPair.new(pa[0], pb[0]))
          yield(pa[0], pa[1], pb[0], pb[1])
        end
      end
    end

    def get_ratio(a, b)
      if a == b
        return 0.5
      elsif a == INF
        return 1.0
      elsif b == INF
        return 0.0
      else 
        return a / (a + b)
      end
    end

    class SortedPair
      attr_reader :min, :max
      def initialize(a, b) @min, @max = [a,b].min, [a,b].max end
      def eql?(other) min.eql?(other.min) && max.eql?(other.max) end
      def hash() [min, max].hash end
    end

    def add_and_return_restricted_body_for(free_body, group)
      id = @current_id
      @current_id += 1
      @body_pool[id] = free_body
      @collision_enabler.add([id, free_body], group) # TODO: Raise domain specific error on limit reached
      return Body.new(self, free_body, id)
    end

  end
end