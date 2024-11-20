cask "last-window-quits" do
  version "1.1.3,2024,11"
  sha256 "2b6645a0910f27a7021828a44a8744e03db7a7a99b75c3d88ad5fc09c31f29e0"

  url "https:lawand.iowp-contentuploads#{version.csv.second}#{version.csv.third}last-window-quits-#{version.csv.first}.zip"
  name "Last Window Quits"
  desc "Automatically quit apps when their last window is closed"
  homepage "https:lawand.iolast-window-quits"

  livecheck do
    url "https:raw.githubusercontent.comlawand-dot-iolast-window-quitsmainappcast.xml"
    regex(%r{(\d+)(\d+)[^]+?$}i)
    strategy :sparkle do |item|
      directories = item&.url&.match(regex)
      next if directories.blank?

      "#{item.short_version},#{directories[1]},#{directories[2]}"
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Last Window Quits.app"

  zap trash: [
    "~LibraryApplication Supportio.lawand.last-window-quits",
    "~LibraryPreferencesio.lawand.last-window-quits.plist",
    "~LWQ Debug Logs",
  ]
end