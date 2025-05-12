cask "maa" do
  version "5.16.4"
  sha256 "81a98fd128650d2a07a5940c16c6ab10a83ad0d9b605911f3e2cc63e72331172"

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