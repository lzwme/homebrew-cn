cask "reactotron" do
  arch arm: "-arm64"

  version "3.7.6"
  sha256 arm:   "879a56cb864cc5911ea019e2b93d182c3a98f200f616126b35e7c80467742dd0",
         intel: "aa8deef8b07a176b2a4d93c2b3b0d0007c1bffafa47312a4fcbe82ea17ae60dd"

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