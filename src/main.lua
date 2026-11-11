--[[
    Copyright (C) 2026 cuhHub

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
]]

function onCreate(is_world_create)
	if is_world_create then
		spawnAll()
	end
end

function spawnAll()
	local addonIndex = server.getAddonIndex()
    local componentIDS = {}

	for locationIndex = 0, server.getAddonData(addonIndex).location_count - 1 do
		local locationData = server.getLocationData(addonIndex, locationIndex)
		if not locationData.env_mod then
			for componentIndex = 0, locationData.component_count - 1 do
				local componentData = server.getLocationComponentData(addonIndex, locationIndex, componentIndex)
				componentIDS[locationData.name] = {id = componentData.id, offset = componentData.transform}
			end
		end
	end

    for name, component in pairs(componentIDS) do
        local spawn_zones = server.getZones(name)
        for _, zone in pairs(spawn_zones) do
            local spawn_transform = matrix.multiply(zone.transform, component.offset)
            server.spawnAddonVehicle(spawn_transform, addonIndex, component.id)
        end
    end
end