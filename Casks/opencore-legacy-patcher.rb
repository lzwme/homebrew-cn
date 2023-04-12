cask "opencore-legacy-patcher" do
  version "0.6.3"
  sha256 "a06154d5f7a1c0da56d106dab1f2305c072237656b0c3975690d1c5b5794dd68"

  url "https://ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur, Monterey and Ventura (11.x-13.x) on unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app"
end