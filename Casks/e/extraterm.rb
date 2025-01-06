cask "extraterm" do
  version "0.80.0"
  sha256 "0648226fd4bbd358d2d0cb189b8ea3c4e37cac05bef1bccb78ce730b3ead3783"

  url "https:github.comsedwards2009extratermreleasesdownloadv#{version}ExtratermQt_#{version}.dmg",
      verified: "github.comsedwards2009extraterm"
  name "extraterm"
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