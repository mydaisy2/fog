Shindo.tests('Fog::Rackspace::AutoScale | group_tests', ['rackspace']) do

  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord


  LINK_FORMAT = {
    'href' => String,
    'rel' => String
  }

  CREATE_GROUP_FORMAT = {
    "group" => {
      "launchConfiguration" => {
        "args" => {
          "loadBalancers"=> [
            {
              "port" => Integer,
              "loadBalancerId" => Integer
            }
          ],
          "server" => {
            "name" => String,
             "imageRef" => String,
             "flavorRef" => Integer,
             "OS-DCF:diskConfig" => String,
             "networks" => [ Hash ],
             "metadata"=> Hash
            }
          },
          "type"=>"launch_server"
        },
        "groupConfiguration" => {
          "maxEntities" => Integer,
          "cooldown" => Integer,
          "name" => String,
          "minEntities" => Integer,
          "metadata" => Hash
        },
        "scalingPolicies" => [{
          "name" => "scale up by 5 server",
          "links"=> [ LINK_FORMAT ],
          "cooldown" => Integer,
          "type" => String,
          "id" => String,
          "change" => Integer
        }],
        "links"=> [ LINK_FORMAT ],
        "id" => String
      }
    }

  LIST_GROUP_FORMAT = {
    "groups_links" => Array,
    "groups" => [
      {
        "desiredCapacity" => Integer,
        "links" => [ LINK_FORMAT ],
        "paused" => Fog::Boolean,
        "active" => Array,
        "pendingCapacity" => Integer,
        "activeCapacity" => Integer,
        "id" => String
      }
    ]
  }

  GROUP_STATE_FORMAT = {
    "group" => {
      "desiredCapacity" => Integer,
      "links" => [LINK_FORMAT],
      "paused" => Fog::Boolean,
      "active" => Array,
      "pendingCapacity" => Integer,
      "activeCapacity" => Integer,
       "id" => String
       }
    }


  group_config = {
    "name" => "fog_scaling_group_#{Time.now.to_i.to_s}",
    "cooldown" => 60,
    "minEntities" => 5,
    "maxEntities" => 25,
    "metadata" => {
      "firstkey" =>  "this is a string",
      "secondkey" =>  "1"
    }
  }

  launch_config = {
    "type" => "launch_server",
    "args" => {
      "server" => {
        "flavorRef" => 3,
        "name" => "webhead",
        "imageRef" => "0d589460-f177-4b0f-81c1-8ab8903ac7d8",
        "OS-DCF:diskConfig" => "AUTO",
        "metadata" => {
          "mykey" =>"myvalue"
        },
        "networks" => [{"uuid"=>"11111111-1111-1111-1111-111111111111"}]
      },
      "loadBalancers" => [
        {
          "loadBalancerId"=>2200,
          "port"=>8081
        }
      ]
    }
  }

   scaling_policy = {
      "name" => "scale up by 5 server",
      "change" => 1,
      "cooldown" => 0,
      "type" =>  "webhook"
   }


  tests('create_group').formats(CREATE_GROUP_FORMAT, false) do
    response = service.create_group(group_config, launch_config, scaling_policy)
    @group_id = response.body["group"]["id"]
    response.body
  end

  tests('list_groups').formats(LIST_GROUP_FORMAT) do
    service.list_groups.body
  end

  tests("get_group(#{@group_id})").formats(CREATE_GROUP_FORMAT) do
    service.get_group(@group_id).body
  end

  tests("get_group_state(#{@group_id})").formats(GROUP_STATE_FORMAT) do
    service.get_group_state(@group_id).body
  end

  tests("pause_group(#{@group_id})").returns(204) do
    pending # this has not been implemented yet
    service.pause_group(@group_id).status
  end

  tests("resume_group(#{@group_id})").returns(204) do
    pending # this has not been implemented yet
    service.resume_group(@group_id).status
  end

  tests('update_config').returns(204) do
    updated_config = {
      "name" => "fog_scaling_group_#{Time.now.to_i.to_s}",
      "cooldown" => 0,
      "minEntities" => 0,
      "maxEntities" => 0,
      "metadata" => {}
    }

    service.update_config(@group_id, updated_config).status
  end

  tests('delete_group').returns(204) do
    service.delete_group(@group_id).status
  end

end