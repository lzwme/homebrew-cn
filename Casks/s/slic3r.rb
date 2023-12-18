cask "slic3r" do
  version "1.3.0"
  sha256 "a50dbe78c4648dfcd0ffec46335554c9fa3348dd494a1f6c2b60406aea57b5cb"

  url "https:github.comslic3rSlic3rreleasesdownload#{version}slic3r-#{version}.dmg",
      verified: "github.comslic3rSlic3r"
  name "Slic3r"
  desc "3D printing toolbox"
  homepage "https:slic3r.org"

  app "Slic3r.app"
  binary "#{appdir}Slic3r.appContentsMacOSSlic3r", target: "slic3r"

  zap trash: [
    "~LibraryApplication SupportSlic3r",
    "~LibraryPreferencesorg.slic3r.Slic3r.plist",
    "~LibrarySaved Application Stateorg.slic3r.Slic3r.savedState",
  ]
end