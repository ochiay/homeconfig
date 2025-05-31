local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local todo_file = os.getenv("HOME") .. "/Documents/todo.org"

-- Чтение строк из todo.org
local function read_lines()
    local lines = {}
    local f = io.open(todo_file, "r")
    if f then
        for line in f:lines() do
            table.insert(lines, line)
        end
        f:close()
    end
    return lines
end

-- Запись строк обратно
local function write_lines(lines)
    local f = io.open(todo_file, "w")
    for _, line in ipairs(lines) do
        f:write(line .. "\n")
    end
    f:close()
end

-- Создаёт кнопку с крестиком
local function create_remove_button(callback)
    local btn_text = wibox.widget {
        text = "❌",
        font = "monospace 12",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    }

    local btn_container = wibox.widget {
        {
            btn_text,
            margins = 3,
            widget = wibox.container.margin,
        },
        shape = gears.shape.rounded_rect,
        bg = "#444444",
        border_width = 1,
        border_color = "#AAAAAA",
        widget = wibox.container.background,
    }

    btn_container:connect_signal("mouse::enter", function()
        btn_container.bg = "#666666"
    end)
    btn_container:connect_signal("mouse::leave", function()
        btn_container.bg = "#444444"
    end)

    btn_container:buttons(gears.table.join(
        awful.button({}, 1, callback)
    ))

    return btn_container
end

-- Функция для открытия Emacs
local function open_todo_in_emacs()
    awful.spawn("emacsclient -n " .. todo_file)
end

-- Основной вертикальный список
local list_layout = wibox.layout.fixed.vertical()

-- Обновление списка
local function update_todo()
    list_layout:reset()

    local lines = read_lines()
    for i, line in ipairs(lines) do
        local text = wibox.widget {
            text = line,
            font = "monospace 12",
            align = "left",
            valign = "center",
            widget = wibox.widget.textbox,
        }

        text:buttons(gears.table.join(
            awful.button({}, 1, open_todo_in_emacs)
        ))

        local remove_btn = create_remove_button(function()
            table.remove(lines, i)
            write_lines(lines)
            update_todo()
        end)

        local row = wibox.widget {
           {
              layout = wibox.layout.align.horizontal,
              expand = nil,
              text,        -- слева
              nil,         -- центр
              remove_btn,  -- справа
                 
            },
            top = 2,
            bottom = 2,
            widget = wibox.container.margin,
        }

        list_layout:add(row)
    end
end

-- Обёртка
local container = wibox.widget {
    {
        list_layout,
        margins = 12,
        widget = wibox.container.margin
    },
    bg = "#22222288",
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 12) end,
    border_width = 2,
    border_color = "#AAAAAA",
    widget = wibox.container.background
}

-- Wibox
local todo_wibox = wibox {
    visible = true,
    ontop = false,
    type = "desktop",
    screen = awful.screen.primary,
    width = 440,
    height = 500,
    x = 1450,
    y = 60,
    bg = "#00000000",
}

todo_wibox:setup {
    container,
    layout = wibox.layout.fixed.vertical,
}

-- Обновляем список сразу и по таймеру
update_todo()

gears.timer {
    timeout = 60,
    autostart = true,
    callback = update_todo
}

return {
    widget = todo_wibox
}
