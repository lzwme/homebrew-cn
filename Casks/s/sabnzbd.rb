cask "sabnzbd" do
  version "4.2.0"
  sha256 "84bdcfb46131cda11077e5674c5185f2811825e4028f642b6bed210953798346"

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