cask "standard-notes" do
  arch arm: "arm64", intel: "x64"

  version "3.183.43"
  sha256 arm:   "147bec550f1263a4614a373e502753a04d5b6e6c74ac98c5e0c316ec7e597add",
         intel: "a183043f7ea51232bb9238618da8a6ec1d2378810ff4b9fa89cfdb9ac5d481e7"

  url "https:github.comstandardnotesappreleasesdownload%40standardnotes%2Fdesktop%40#{version}standard-notes-#{version}-mac-#{arch}.zip",
      verified: "github.comstandardnotesapp"
  name "Standard Notes"
  desc "Free, open-source, and completely encrypted notes app"
  homepage "https:standardnotes.org"

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
    "~LibraryCachesorg.standardnotes.standardnotes.ShipIt",
    "~LibraryCachesorg.standardnotes.standardnotes",
    "~LibraryPreferencesorg.standardnotes.standardnotes.helper.plist",
    "~LibraryPreferencesorg.standardnotes.standardnotes.plist",
    "~LibrarySaved Application Stateorg.standardnotes.standardnotes.savedState",
  ]
end