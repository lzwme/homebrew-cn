cask "sabnzbd" do
  version "4.1.0"
  sha256 "8148d22f657efeff7522f97fe695cf507cc051164cb089d0465ceb44564f7b7a"

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