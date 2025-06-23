cask "maa" do
  version "5.18.1"
  sha256 "fbe0150a4eda2331dbf6dbe72e52a1c69a7156ddd8e668dccd53b804634b89a4"

  url "https:github.comMaaAssistantArknightsMaaAssistantArknightsreleasesdownloadv#{version}MAA-v#{version}-macos-universal.dmg"
  name "MAA"
  desc "One-click tool for the daily tasks of Arknights"
  homepage "https:github.comMaaAssistantArknightsMaaAssistantArknights"

  livecheck do
    url "https:maa-release.hguandl.commacosappcast.xml"
    strategy :sparkle do |items|
      items.find { |item| item.channel.nil? }&.short_version&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "MAA.app"

  zap trash: [
    "~LibraryApplication Scriptscom.hguandl.MeoAsstMac",
    "~LibraryContainerscom.hguandl.MeoAsstMac",
  ]
end