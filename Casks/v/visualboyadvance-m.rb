cask "visualboyadvance-m" do
  version "2.1.9"
  sha256 "19e8c184ae5f50514a41c366ccf0ab15e04195f95554e1af077009cc947162a3"

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
end