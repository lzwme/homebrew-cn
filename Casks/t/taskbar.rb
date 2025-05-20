cask "taskbar" do
  version "1.4.5,2025,05"
  sha256 "87b76ece1c884be99e07367f0f6dfa1355034fc7a18911daf396cf20c2dea501"

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
    "~LibraryCachescom.fpfxtknjju.wbgcdolfev",
    "~LibraryHTTPStoragescom.fpfxtknjju.wbgcdolfev",
    "~LibraryLaunchAgentscom.fpfxtknjju.wbgcdolfev.plist",
    "~LibraryPreferencescom.fpfxtknjju.wbgcdolfev.plist",
    "~LibraryWebKitcom.fpfxtknjju.wbgcdolfev",
  ]
end