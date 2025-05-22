cask "maa" do
  version "5.16.8"
  sha256 "65ab1a108f4f431f2988418dccc33495c2d440a32d54be4f864a6678282e1251"

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