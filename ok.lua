for _, obj in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
    if obj:IsA("TextButton") then
        print("Found TextButton - Name: " .. obj.Name .. " | Text: " .. obj.Text .. " | ClassName: " .. obj.ClassName)
    end
end
