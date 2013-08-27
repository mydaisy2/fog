module Fog
  module Rackspace
    class AutoScale
      class Real

          def create_group(group_config, launch_config, scaling_policies)

            data = {
              "groupConfiguration" => group_config,
              "launchConfiguration" => launch_config,
              "scalingPolicies" => scaling_policies.is_a?(Array) ? scaling_policies : [scaling_policies]
            }

          request(
            :expects => [201],
            :method => 'POST',
            :path => 'groups',
            :body => Fog::JSON.encode(data)
            )
        end
      end

      class Mock
        def create_group
          Fog::Mock.not_implemented

        end
      end
    end
  end
end
