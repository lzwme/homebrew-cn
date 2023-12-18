cask "visualboyadvance-m" do
  version "2.1.8"
  sha256 "89399615c7e4e48cc6024e3c3b30ddf58eef5dcb2589dbf982cfc3d6d502ed7f"

  url "https:github.comvisualboyadvance-mvisualboyadvance-mreleasesdownloadv#{version}visualboyadvance-m-Mac-x86_64.zip",
      verified: "github.comvisualboyadvance-mvisualboyadvance-m"
  name "Visual Boy Advance - M"
  desc "Game Boy Advance emulator"
  homepage "https:vba-m.com"

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