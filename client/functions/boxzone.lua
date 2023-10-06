function Taxi.Methods.CreateBoxZone(location)
    return BoxZone:Create(
        vector3(location.xyz),
        20,
        10,
        {
            heading = location.w,
            debugPoly = not Config.production,
            minZ = location.z - 1,
            maxZ = location.z + 1,
        }
    )
end
