cask "reactotron" do
  arch arm: "-arm64"

  version "3.1.1"
  sha256 arm:   "5b944d1c69169b521f8619f012d5f4c6b7e00bc664e18e13e2426d4ea8d0801f",
         intel: "87dbd34a957891829002ef99e5d39866489234e6bbb0a4e153bab66c177ca44d"

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