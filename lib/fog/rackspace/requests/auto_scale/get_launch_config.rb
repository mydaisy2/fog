module Fog
  module Rackspace
    class AutoScale

      class Real

        def launch_group(group_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "groups/#{group_id}/launch",
            )
        end
      end

      class Mock
        def launch_group(group_id)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end