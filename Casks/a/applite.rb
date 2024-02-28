cask "applite" do
  version "1.2.3"
  sha256 "ed35b6b5c6dcc3fe90ba17d7633d24780d1f86c1484499ab9028b41b2f567078"

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