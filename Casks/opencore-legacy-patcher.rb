cask "opencore-legacy-patcher" do
  version "0.6.6"
  sha256 "826fc8ad0673dbb787d6a09f10c94d8b3497344be2e9c45eb45768597e1e43b4"

  url "https://ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur, Monterey and Ventura (11.x-13.x) on unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app"
end