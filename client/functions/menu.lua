function Taxi.Methods.CreateMenu()
    local menu = {}

    local function add(data)
        menu[#menu + 1] = data
    end

    local methods = {}

    function methods.setHeader(header)
        add({
            header = header,
            isMenuHeader = true
        })
        return methods
    end

    function methods.setOption(header, text, params)
        add({
            header = header,
            txt = text,
            params = params
        })
        return methods
    end

    function methods.build()
        add({
            header = Lang:t("menu.close_menu"),
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        })
        exports['qb-menu']:openMenu(menu)
    end

    return methods
end


function Taxi.Methods.CloseMenu()
    exports['qb-menu']:closeMenu()
end
