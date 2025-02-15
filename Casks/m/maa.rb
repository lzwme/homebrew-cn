cask "maa" do
  version "5.13.1"
  sha256 "bd4a04b40fb926c3c7c2acc5d3923a9b50139decdb5c053d0bb0f15d0f2676ef"

  url "https:github.comMaaAssistantArknightsMaaAssistantArknightsreleasesdownloadv#{version}MAA-v#{version}-macos-universal.dmg"
  name "MAA"
  desc "One-click tool for the daily tasks of Arknights"
  homepage "https:github.comMaaAssistantArknightsMaaAssistantArknights"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "MAA.app"

  zap trash: [
    "~LibraryApplication Scriptscom.hguandl.MeoAsstMac",
    "~LibraryContainerscom.hguandl.MeoAsstMac",
  ]
end