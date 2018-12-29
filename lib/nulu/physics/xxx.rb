module Nulu

  # Next Steps
  #  - Update time properly (save max and min) (usar como guia el link de gamedev del chabón cra)
  # https://gamedev.stackexchange.com/questions/26888/finding-the-contact-point-with-sat
  # https://gamedev.stackexchange.com/questions/60054/separate-axis-theorem-applied-to-aabb-misunderstood

  module XXX

    # TODO: Receive two 'entities'
    def self.get_collision_time(a, velocity_a, b, velocity_b)
      max_earlier_time = 0
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
          if projected_rel_velocity_a >= 1e-6 # will stop colliding at some point
            latter_time = (maxb - mina) / projected_rel_velocity_a
            min_latter_time = [min_latter_time, latter_time].min
          end
        else # separated
          if projected_rel_velocity_a >= 1e-6 # will collide at some point
            earlier_time = (minb - maxa) / projected_rel_velocity_a
            latter_time = (maxb - mina) / projected_rel_velocity_a
            max_earlier_time = [max_earlier_time, earlier_time].max
            min_latter_time = [min_latter_time, latter_time].min
          else # will never collide
            return nil
          end
        end
      end

      return max_earlier_time <= min_latter_time ? max_earlier_time : nil
    end

#      def self.zzz(a, velocity_a, b, velocity_b)
#      colliding = true
#      mtv = Point.new(INF, INF)
#
#      max_earlier_time = 0
#      min_latter_time = INF
#
#      axes = (a.segments + b.segments).map(&:direction)
#                                      .map(&:perp).map(&:unit)
#
#      axes.each do |axis|
#        # shape projection
#        mina, maxa = a.vertex.map{ |v| v * axis }.minmax
#        minb, maxb = b.vertex.map{ |v| v * axis }.minmax
#
#        o = 0       # overlap
#        neg = false # direction (relative to axis)
#
#        # ensuring mina < minb
#        unless mina < minb
#          velocity_a = -velocity_a # no está chequeado
#          velocity_b = -velocity_b # no está chequeado
#          mina, maxa = -maxa, -mina
#          minb, maxb = -maxb, -minb
#          neg = !neg
#        end
#
#        if maxb <= maxa || minb <= maxa # overlapped
#          # find overlap
#          if maxb <= maxa # containment
#            o = maxb - minb
#            if minb - mina < maxa - maxb
#              o += minb - mina
#            else
#              o += maxa - maxb
#              neg = !neg
#            end
#          elsif minb <= maxa # intersection
#            o = maxa - minb
#          else # separated
#            return nil
#          end
#          # mtv update
#          if o < mtv.norm
#            mtv = axis * (neg ? -o : o)
#          end
#
#        else # separated
#
#          # mark as non-colliding
#          colliding = false
#
#          # find time of collision
#          projected_velocity_diff = (velocity_a - velocity_b) * axis
#          if projected_velocity_diff >= 1e-6 # will collide at some point
#            earlier_time = (minb - maxa) / projected_velocity_diff
#            latter_time = (maxb - maxa) / projected_velocity_diff
#            max_earlier_time = max(max_earlier_time, earlier_time)
#            min_latter_time = min(min_latter_time, latter_time)
#          else
#            return nil
#          end
#        end
#      end
#
#      if colliding
#        return [0, mtv]
#      elsif collision_time != INF
#        return [collision_time, Nulu::Vector.new(0, 0)]
#      else
#        return nil
#      end
#    end
# end


  end
end