cask "sabnzbd" do
  version "4.3.3"
  sha256 "bfaf22c8008d4c95ad467f381e8ce070de7d752a0b0d4cd20593e64c04d95653"

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