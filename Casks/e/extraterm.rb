cask "extraterm" do
  version "0.79.0"
  sha256 "e2c265e2bf0567de74bbbe5c324bb8c6183db92cfb7396d6faef7e0b291cf007"

  url "https:github.comsedwards2009extratermreleasesdownloadv#{version}ExtratermQt_#{version}.dmg",
      verified: "github.comsedwards2009extraterm"
  name "extraterm"
  desc "Swiss army chainsaw of terminal emulators"
  homepage "https:extraterm.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ExtratermQt.app"

  zap trash: [
    "~LibraryApplication Supportextraterm",
    "~LibraryPreferencescom.electron.extraterm*.plist",
  ]

  caveats do
    requires_rosetta
  end
end