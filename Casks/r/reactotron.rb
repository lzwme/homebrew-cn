cask "reactotron" do
  arch arm: "-arm64"

  version "3.3.0"
  sha256 arm:   "964cc46e43fd5e7db9151ab8b8e7ab8746f05ced9c7aa6276af35094ad7fd7c0",
         intel: "dd8474d47c2512ba43eb99c68b45d36dea6becd90386343ae22227b29131e760"

  url "https:github.cominfiniteredreactotronreleasesdownloadreactotron-app%40#{version}Reactotron-#{version}#{arch}-mac.zip"
  name "Reactotron"
  desc "Desktop app for inspecting React JS and React Native projects"
  homepage "https:github.cominfiniteredreactotron"

  # Upstream publishes multiple packages in the same repository and, due to the
  # number of packages that are updated around the same time, the most recent
  # releases may not be for the app. This check searches for `reactotron-app`
  # releases, as the `GithubReleases` strategy may be unreliable in this
  # scenario.
  livecheck do
    url "https:github.cominfiniteredreactotronreleases?q=reactotron-app+prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?tagreactotron-app(?:%40|@)v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Reactotron.app"

  zap trash: [
    "~LibraryApplication SupportReactotron",
    "~LibraryLogsReactotron",
    "~LibraryPreferencescom.reactotron.app.helper.plist",
    "~LibraryPreferencescom.reactotron.app.plist",
    "~LibrarySaved Application Statecom.reactotron.app.savedState",
  ]
end