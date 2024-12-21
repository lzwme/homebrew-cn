cask "taskbar" do
  version "1.2.6,2024,12"
  sha256 "9090ea8e66f0f0a49b00717c869537675c3c5b523b5dce097071327fa69fa02c"

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