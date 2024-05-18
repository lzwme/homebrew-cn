cask "applite" do
  version "1.2.5"
  sha256 "c03474eb4b839b860ab3e12d076d74a3b03f5946d1c9621384563cb04e9ce3f1"

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