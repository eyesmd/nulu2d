module Nulu

  class XXX

    DEFAULT_GROUP_LIMIT = 100

    def initialize(group_limit = DEFAULT_GROUP_LIMIT)
      # TODO: Raise domain specific error
      @groups = {}
      @collision_graph = Graph.new(group_limit, true)
    end

    def add(shape, group = :nulu_default)
      @groups[group] = [] unless @groups[group]
      @groups[group] << shape
      @collision_graph.add_node(group)
    end

    def disable_collision_within(group)
      @collision_graph.add_node(group)
      @collision_graph.remove_edge(group, group)
    end

    def disable_collision_between(group_a, group_b)
      @collision_graph.add_node(group_a)
      @collision_graph.add_node(group_b)
      @collision_graph.remove_edge(group_a, group_b)
    end

    def enable_collision_within(group)
      @collision_graph.add_node(group)
      @collision_graph.add_edge(group, group)
    end

    def enable_collision_between(group_a, group_b)
      @collision_graph.add_node(group_a)
      @collision_graph.add_node(group_b)
      @collision_graph.add_edge(group_a, group_b)
    end


    def each_collidable_pair()
      @collision_graph.each_connected_pair do |group_a, group_b|
        if group_a == group_b
          shapes = @groups[group_a]
          shape_count = shapes.size
          (0...shape_count).each do |i|
            (i+1...shape_count).each do |j|
              yield(shapes[i], shapes[j])
            end
          end
        else
          shapes_a = @groups[group_a]
          shapes_b = @groups[group_b]
          shapes_a.each do |shape_a|
            shapes_b.each do |shape_b|
              yield(shape_a, shape_b)
            end
          end
        end
      end
    end

  end
end