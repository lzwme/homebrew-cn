cask "standard-notes" do
  arch arm: "arm64", intel: "x64"

  version "3.191.4"
  sha256 arm:   "b4b391c6b3db3c08d87ac57d05bd98e214875c1a4c6ef591a9af52e57ea36bab",
         intel: "58793293416828dae03e04b93d27593c01bd0edb7e8049107ff85f036269b993"

  url "https:github.comstandardnotesappreleasesdownload%40standardnotes%2Fdesktop%40#{version}standard-notes-#{version}-mac-#{arch}.zip",
      verified: "github.comstandardnotesapp"
  name "Standard Notes"
  desc "Free, open-source, and completely encrypted notes app"
  homepage "https:standardnotes.com"

  # The app's auto-updater avoids versions marked as "pre-release" on GitHub,
  # so we do the same thing in this check.
  # See: https:github.comHomebrewhomebrew-caskpull145753#issuecomment-1521465815
  # We specifically check the GitHub releases page with the `prerelease:false`
  # query (instead of using the `GithubReleases` strategy) because upstream
  # publishes a lot of pre-release versions and they may push the most recent
  # stable desktop release out of the most recent info from the GitHub API.
  livecheck do
    url "https:github.comstandardnotesappreleases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?tag%40standardnotes%2Fdesktop%40(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Standard Notes.app"

  zap trash: [
    "~LibraryApplication SupportStandard Notes",
    "~LibraryCachesorg.standardnotes.standardnotes",
    "~LibraryCachesorg.standardnotes.standardnotes.ShipIt",
    "~LibraryPreferencesorg.standardnotes.standardnotes.helper.plist",
    "~LibraryPreferencesorg.standardnotes.standardnotes.plist",
    "~LibrarySaved Application Stateorg.standardnotes.standardnotes.savedState",
  ]
end