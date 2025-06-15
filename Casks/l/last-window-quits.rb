cask "last-window-quits" do
  version "1.1.4,2024,12"
  sha256 "10938d6cd6e201914d3041673509891f80e102c6fa78be8ddf1c3caed1fd862d"

  url "https:lawand.iowp-contentuploads#{version.csv.second}#{version.csv.third}last-window-quits-#{version.csv.first}.zip"
  name "Last Window Quits"
  desc "Automatically quit apps when their last window is closed"
  homepage "https:lawand.iolast-window-quits"

  livecheck do
    url "https:raw.githubusercontent.comlawand-dot-iolast-window-quitsmainappcast.xml"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :sparkle do |item, regex|
      match = item.url&.match(regex)
      next if match.blank?

      "#{item.short_version},#{match[1]},#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Last Window Quits.app"

  zap trash: [
    "~LibraryApplication Supportio.lawand.last-window-quits",
    "~LibraryHTTPStoragesio.lawand.last-window-quits",
    "~LibraryLaunchAgentsio.lawand.last-window-quits.plist",
    "~LibraryPreferencesio.lawand.last-window-quits.plist",
    "~LWQ Debug Logs",
  ]
end