module Fog
  module Rackspace
    class AutoScale

      class Real

        def update_config(group_id, options)

          request(
            :expects => [204],
            :method => 'PUT',
            :path => "groups/#{group_id}/config",
            :body => Fog::JSON.encode(options))
        end
      end

      class Mock
        def update_config(group_id, options)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end