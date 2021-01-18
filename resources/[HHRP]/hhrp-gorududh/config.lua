Config = {}
Config.Locale = 'en'
Config.Model = "a_c_cow"
Config.NeedJob = true
Config.Job = "milker"
Config.Text3d = true
Config.WaitTime = 0 -- In Seconds
Config.PrizeItem = "milkcan"
Config.PrizeLabel = "Milk Can"
Config.ItemPrice = 30
Config.SellTime = 2 -- In Seconds
Config.PrizeMin = 1
Config.PrizeMax = 3
Config.TimeToEnd = 40 -- In Seconds
Config.TakingLabel = "Taking Milk | " .. Config.TimeToEnd .. " Seconds"

Config.Cows = {
    {1136.73, -2352.22, 30.2},
    {1131.05, -2354.19, 30.0},
    {1135.52, -2355.72, 30.35},
    {1134.41, -2365.31, 30.35}
}

Config.Blips = {
  {title="Cows", colour=4, id=141, x = 1136.73,size=0.8, y = -2352.22, z = 30.2},
  {title="Milk Sell", colour=37, id=467,size=0.0, x = 51.29, y = -1317.92, z = 29.29},
}
