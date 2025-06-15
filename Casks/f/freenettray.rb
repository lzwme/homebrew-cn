cask "freenettray" do
  version "2.2.0"
  sha256 "1351ee80def91f0fd7bb0903921d1987070e38787eacdb0ae8801b8f52bf0dac"

  url "https:github.comfreenetmactrayreleasesdownloadv#{version}FreenetTray_#{version}.zip",
      verified: "github.comfreenetmactray"
  name "Freenet"
  desc "Menu bar application to control Freenet"
  homepage "https:freenetproject.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-10", because: :unmaintained

  app "FreenetTray.app"

  zap trash: [
    "~LibraryApplication SupportFreenet",
    "~LibraryPreferencesorg.freenetproject.mactray.plist",
  ]

  caveats do
    requires_rosetta
  end
end