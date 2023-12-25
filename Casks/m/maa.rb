cask "maa" do
  version "4.28.4"
  sha256 "22c8e61c7b3dd1179caf70d0e86b474d2abb06819afc1fe00a7d375fcdde24dc"

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