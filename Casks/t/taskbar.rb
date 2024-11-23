cask "taskbar" do
  version "1.2.5,2024,09"
  sha256 "b372de00cfbfaebafdc7efd13d0d1ec25f01a1f296bdbe207f17f57e8e17d916"

  url "https:lawand.iowp-contentuploads#{version.csv.second}#{version.csv.third}taskbar-#{version.csv.first}.zip"
  name "Taskbar"
  desc "Windows-style taskbar as a Dock replacement"
  homepage "https:lawand.iotaskbar"

  livecheck do
    url "https:raw.githubusercontent.comlawand-dot-iotaskbarmainappcast.xml"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :sparkle do |item, regex|
      match = item.url&.match(regex)
      next if match.blank?

      "#{item.short_version},#{match[1]},#{match[2]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Taskbar.app"

  zap trash: [
    "~LibraryHTTPStoragescom.fpfxtknjju.wbgcdolfev",
    "~LibraryLaunchAgentscom.fpfxtknjju.wbgcdolfev.plist",
    "~LibraryPreferencescom.fpfxtknjju.wbgcdolfev.plist",
  ]
end