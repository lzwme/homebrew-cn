cask "applite" do
  version "1.3.1"
  sha256 "7c2972f21f373c1f64518212098a76604f14b05bd56eb7e56f84c25f4c9c8da2"

  url "https:github.commilanvaradyApplitereleasesdownloadv#{version}Applite.dmg",
      verified: "github.commilanvaradyApplite"
  name "Applite"
  desc "User-friendly GUI app for Homebrew"
  homepage "https:aerolite.devapplite"

  livecheck do
    url "https:milanvarady.github.ioAppliteappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Applite.app"

  zap trash: [
    "~LibraryApplication SupportApplite",
    "~LibraryApplication Supportdev.aerolite.Applite",
    "~LibraryCachesApplite",
    "~LibraryCachesdev.aerolite.Applite",
    "~LibraryContainersdev.aerolite.Applite",
    "~LibraryHTTPStoragesdev.aerolite.Applite",
    "~LibraryPreferencesdev.aerolite.Applite.plist",
    "~LibrarySaved Application Statedev.aerolite.Applite.savedState",
  ]
end