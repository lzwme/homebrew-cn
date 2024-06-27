cask "extraterm" do
  version "0.78.1"
  sha256 "ce8ac100098c96c0fa1ebdfee962b9881bf139b4065c3d9e547b908d6f35deaa"

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
end