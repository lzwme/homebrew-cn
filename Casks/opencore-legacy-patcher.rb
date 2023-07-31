cask "opencore-legacy-patcher" do
  version "0.6.8"
  sha256 "996cbf77d08a5ac6a13403ada89858ce9f5184a99e94788178e321d8fd49caab"

  url "https://ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur, Monterey and Ventura (11.x-13.x) on unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app", target: "/Library/Application Support/Dortania/OpenCore-Patcher.app"
end