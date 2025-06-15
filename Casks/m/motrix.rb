cask "motrix" do
  arch arm: "-arm64"

  version "1.8.19"
  sha256 arm:   "d73f4d69f3597ad8f98b821aa0fb58ba964bf85061b4a13f00edcb3618001c0e",
         intel: "b644cc83aa98224147ef2942fd49ecfc8cdcebfce9616550fa35caa6850c4178"

  url "https:github.comagalwoodMotrixreleasesdownloadv#{version}Motrix-#{version}#{arch}.dmg",
      verified: "github.comagalwoodMotrix"
  name "Motrix"
  desc "Open-source download manager"
  homepage "https:motrix.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Motrix.app"

  zap trash: [
    "~LibraryApplication SupportMotrix",
    "~LibraryCachesapp.motrix.native",
    "~LibraryLogsMotrix",
    "~LibraryPreferencesapp.motrix.native.plist",
    "~LibrarySaved Application Stateapp.motrix.native.savedState",
  ]
end