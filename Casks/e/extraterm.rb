cask "extraterm" do
  version "0.81.0"
  sha256 "f6d8d5dccfebe35e9f4a8d0f58f44a9654dcb717b282828b7112c043b66daab0"

  url "https:github.comsedwards2009extratermreleasesdownloadv#{version}ExtratermQt_#{version}.dmg",
      verified: "github.comsedwards2009extraterm"
  name "Extraterm"
  desc "Swiss army chainsaw of terminal emulators"
  homepage "https:extraterm.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "ExtratermQt.app"

  zap trash: [
    "~LibraryApplication Supportextraterm",
    "~LibraryPreferencescom.electron.extraterm*.plist",
  ]

  caveats do
    requires_rosetta
  end
end