cask "applite" do
  version "1.2.4"
  sha256 "b72d7e655c25ec6ef4fa89730255ed2c5617ce4b7e26e43f793801f6c9ac6468"

  url "https:github.commilanvaradyApplitereleasesdownloadv#{version}Applite.dmg",
      verified: "github.commilanvaradyApplite"
  name "Applite"
  desc "User-friendly GUI app for Homebrew"
  homepage "https:aerolite.devapplite"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :ventura"
  depends_on formula: "pinentry-mac"

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