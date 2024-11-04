cask "maa" do
  version "5.9.0"
  sha256 "197f5ea396c8ac04be2a617c73a5543f45b7138a9eb2979f13bae4115a0712aa"

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