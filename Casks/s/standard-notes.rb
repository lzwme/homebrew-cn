cask "standard-notes" do
  arch arm: "arm64", intel: "x64"

  version "3.194.13"
  sha256 arm:   "0fba480db845336b5257f25e4de8579645f0e1421bb09591b457b0385da4ab7e",
         intel: "8ccc921a25c3056eec0811fc45f39b1422d9af0a796966b4cfe51850d00d7519"

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