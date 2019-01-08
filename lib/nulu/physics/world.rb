module Nulu
  class World

    # Known Simulation Issues
    # - In complex scenarios (example: object falling in a slope with finite mass), 
    #   the iterations needed for a proper response provokes a significant slowdown
    # - Not necesarily a problem, but multiple objects pushing one another get
    #   correctly resolved via iterating
    # - When objects push each other, they jitter: Friction is applied inmediatly
    #   upon object collision. In the current scheme of collision resolving, this
    #   makes for 'non-deterministic' behaviour: the overall result depends on which
    #   collisions are solved first (example: upon A and B colliding: A colliding
    #   with floor, then A and B colliding, then B colliding with floor; results
    #   in A and B colliding, but having different velocities).
    ##

    COLLISION_LOOP_TRIES = 100

    def initialize()
      @entity_pool = Hash.new()
      @normals = Hash.new()
      @current_id = 0
    end

    def make_entity(shape, mass, friction = 0.0)
      entity = Entity.new(shape, mass, friction)
      return add_and_return_controller_for(entity)
    end

    def make_static_entity(shape, friction = 0.0)
      entity = Entity.new(shape, INF, friction)
      entity.gravityless = true
      return add_and_return_controller_for(entity)
    end


    def get_entity_normal(id)
      return @normals[id]
    end


    def update(delta)
      # Gravity
      @entity_pool.each do |id, entity|
        next if entity.gravityless
        entity.velocity.y -= 4
      end

      # Initialize normals
      @normals.clear()
      @entity_pool.each do |id, entity|
        @normals[id] = Nulu::Vector.new(0, 0)
      end

      # Main loop
      tries = COLLISION_LOOP_TRIES
      time_left = delta

      while time_left >= 1e-3 && tries >= 0

        # Defensive separation
        separate_entities()

        # Find earliest collision
        earliest_collision_time = nil
        earliest_collision_normal = nil
        earliest_collision_entity_a = nil
        earliest_collision_entity_b = nil
        earliest_collision_entity_id_a = nil
        earliest_collision_entity_id_b = nil

        @entity_pool.each do |id_a, a|
          @entity_pool.each do |id_b, b|
            next if a == b
            collision_time, collision_normal = Collision::get_collision_time_and_normal(a.shape, a.velocity, b.shape, b.velocity)
            if collision_time && collision_time <= time_left
              # there will be collision
              if !earliest_collision_time || collision_time <= earliest_collision_time
                # earliest collision update
                earliest_collision_time = collision_time
                earliest_collision_normal = collision_normal
                earliest_collision_entity_a = a
                earliest_collision_entity_b = b
                earliest_collision_entity_id_a = id_a
                earliest_collision_entity_id_b = id_b
              end
            end
          end
        end

        # Goto earliest collision
        if earliest_collision_time
          elapsed_time = earliest_collision_time * 0.999
        else 
          elapsed_time = time_left
        end

        @entity_pool.each do |id, entity|
          entity.move(entity.velocity * elapsed_time)
        end

        # Collision Response
        if earliest_collision_time && earliest_collision_normal

          # Renaming
          a = earliest_collision_entity_a
          b = earliest_collision_entity_b
          id_a = earliest_collision_entity_id_a
          id_b = earliest_collision_entity_id_b

          # Save (for normal calculation)
          prev_a_velocity = a.velocity.clone()
          prev_b_velocity = b.velocity.clone()

          # Decomposition
          a_velocity_into_plane, a_velocity_along_plane = a.velocity.decompose_into(earliest_collision_normal)
          b_velocity_into_plane, b_velocity_along_plane = b.velocity.decompose_into(earliest_collision_normal)

          # Velocity into plane
          a_mass_ratio = get_ratio(a.mass, b.mass)
          new_velocity_into_plane = a_velocity_into_plane * a_mass_ratio + b_velocity_into_plane * (1.0 - a_mass_ratio)

          # Velocity along plane (friction)
          if a.frictionless || b.frictionless
            velocity_keep = 1.0
          else 
            velocity_keep = (1.0 - a.friction) * (1.0 - b.friction)
          end

          # Apply velocity
          a.velocity = a_velocity_along_plane * velocity_keep + new_velocity_into_plane
          b.velocity = b_velocity_along_plane * velocity_keep + new_velocity_into_plane

          # Normal calculation
          @normals[id_a] += a.velocity - prev_a_velocity
          @normals[id_b] += b.velocity - prev_b_velocity
        end

        # Advance cycle
        time_left -= elapsed_time
        tries-= 1
      end

      # If there's still time left, screw it, we ignore collisions and just do it
      @entity_pool.each do |id, entity|
        entity.move(entity.velocity * time_left)
      end
      separate_entities()

    end


    private

    # TODO: Could be more robust
    def separate_entities()
      @entity_pool.each do |id_a, a|
        @entity_pool.each do |id_b, b|
          next if a == b
          if Nulu::Collision.colliding?(a.shape, b.shape)
            mtv = Nulu::Collision.mtv(a.shape, b.shape)
            a_mass_ratio = get_ratio(a.mass, b.mass)
            b.move(mtv * a_mass_ratio)
            a.move(-mtv * (1.0 - a_mass_ratio))
          end
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

    def add_and_return_controller_for(entity)
      @current_id += 1
      id = @current_id - 1
      @entity_pool[id] = entity
      return EntityController.new(self, entity, id)
    end

  end
end