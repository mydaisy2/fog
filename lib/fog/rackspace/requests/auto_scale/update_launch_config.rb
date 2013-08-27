module Fog
  module Rackspace
    class AutoScale

      class Real

        def update_launch_config(group_id, options)

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/launch",
            :body => Fog::JSON.encode(option))
        end
      end

      class Mock
        def update_launch_config(group_id, options)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end