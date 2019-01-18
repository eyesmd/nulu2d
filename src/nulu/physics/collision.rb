module Nulu

  module Collision

    # Returns the time and collision normal at which two shapes
    # with certain velocities will collide.
    # If they're already colliding, time is 0 and normal is nil.
    # If they won't ever collide, nil is returned.
    # Uses a modified version of SAT, based on Ron Levin's mails (see
    # README). This implies that it only works for *convex* polygons.
    def self.get_collision_time_and_normal(a, velocity_a, b, velocity_b)
      max_earlier_time = 0
      collision_normal = nil
      min_latter_time = INF

      axes = (a.segments + b.segments).map(&:direction)
                                      .map(&:perp).map(&:unit)

      axes.each do |axis|
        # project
        mina, maxa = a.vertex.map{ |v| v * axis }.minmax
        minb, maxb = b.vertex.map{ |v| v * axis }.minmax
        projected_rel_velocity_a = (velocity_a - velocity_b) * axis

        # ensure mina < minb
        unless mina < minb
          axis = -axis
          mina, maxa = -maxa, -mina
          minb, maxb = -maxb, -minb
          projected_rel_velocity_a = -projected_rel_velocity_a
        end

        if minb <= maxa # overlapped
          if projected_rel_velocity_a.abs >= 1e-6 # will stop colliding at some point
            if projected_rel_velocity_a >= 0
              latter_time = (maxb - mina) / projected_rel_velocity_a
            else 
              latter_time = (maxa - minb) / (-projected_rel_velocity_a)
            end
            min_latter_time = [min_latter_time, latter_time].min
          end
        else # separated
          if projected_rel_velocity_a >= 1e-6 # will collide at some point
            earlier_time = (minb - maxa) / projected_rel_velocity_a
            latter_time = (maxb - mina) / projected_rel_velocity_a
            if earlier_time > max_earlier_time
              max_earlier_time = earlier_time
              collision_normal = axis
            end
            if latter_time < min_latter_time 
              min_latter_time = latter_time
            end 
          else # will never collide
            return nil
          end
        end
      end

      if max_earlier_time <= min_latter_time
        [max_earlier_time, collision_normal]
      else 
        nil
      end
    end

  end
end