local ScriptInstance = Instance.new("Script")
ScriptInstance.Name = "DesyncServer"
ScriptInstance.Source = [[
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RE = ReplicatedStorage:WaitForChild("RE")
local QuantumCloner = RE:WaitForChild("QuantumCloner")
local OnTeleport = QuantumCloner:WaitForChild("OnTeleport")

OnTeleport.OnServerEvent:Connect(function(player)
    local char = player.Character
    if not char then return end
    local backpack = player:FindFirstChild("Backpack")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and backpack then
        -- Unequip all tools except Quantum Cloner
        for _,tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Quantum Cloner" then
                humanoid:UnequipTools()
                tool.Parent = backpack
                if tool:FindFirstChild("Activate") then
                    pcall(function() tool:Activate() end)
                end
            end
        end
        -- Equip Quantum Cloner
        local qc = backpack:FindFirstChild("Quantum Cloner") or char:FindFirstChild("Quantum Cloner")
        if qc then
            humanoid:EquipTool(qc)
            pcall(function() qc:Activate() end)
            -- Try to swap body using Quantum Cloner UI button (server-side, may need extra logic if button is client-only)
        end
        -- Find clone and anchor it so it looks frozen/laggy
        local cloneName = tostring(player.UserId).."_Clone"
        local clone = workspace:FindFirstChild(cloneName)
        if clone and clone:FindFirstChild("HumanoidRootPart") then
            clone.HumanoidRootPart.Anchored = true
        end
    end
end)
]]
ScriptInstance.Parent = game:GetService("ServerScriptService")