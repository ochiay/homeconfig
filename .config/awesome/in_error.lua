local naughty = require("naughty")

naughty.config.presets.critical={fg="#f1f1f1",bg="#EFE4E435"}

if awesome.startup_errors then
   naughty.notify({-- preset = naughty.config.presets.critical,
         bg = "#ddd",timout=10,
         title = "Oops, there were errors during startup!",
         text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.connect_signal(
      "debug::error", function (err)
         if in_error then return end
         in_error = true
         
         naughty.notify(
            { preset = naughty.config.presets.critical,
              title = "Oops, an error happened!",
              text = tostring(err) }
         )
         
         in_error = false
   end)
end
