cask "visualboyadvance-m" do
  version "2.1.11"
  sha256 "fbb90afdb6aae1f67ea1aab1e5eca2e0098a76d2f9cb8127b1263555e8d6523b"

  url "https:github.comvisualboyadvance-mvisualboyadvance-mreleasesdownloadv#{version}visualboyadvance-m-Mac-x86_64.zip",
      verified: "github.comvisualboyadvance-mvisualboyadvance-m"
  name "Visual Boy Advance - M"
  desc "Game Boy Advance emulator"
  homepage "https:visualboyadvance-m.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "visualboyadvance-m.app"

  zap trash: [
    "~LibraryApplication Supportvisualboyadvance-m",
    "~LibraryPreferencesvisualboyadvance-m.plist",
  ]

  caveats do
    requires_rosetta
  end
end