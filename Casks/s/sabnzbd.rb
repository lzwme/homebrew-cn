cask "sabnzbd" do
  version "4.3.2"
  sha256 "fd2380827cc09f1043b5f658b3236a49fdc8cddf27cd3ef348463f70cc34ca9c"

  url "https:github.comsabnzbdsabnzbdreleasesdownload#{version}SABnzbd-#{version}-osx.dmg",
      verified: "github.comsabnzbdsabnzbd"
  name "SABnzbd"
  desc "Binary newsreader"
  homepage "https:sabnzbd.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "SABnzbd.app"

  zap trash: "~LibraryApplication SupportSABnzbd"
end