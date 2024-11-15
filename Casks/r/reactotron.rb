cask "reactotron" do
  arch arm: "-arm64"

  version "3.7.4"
  sha256 arm:   "b21cd06b7962bd7b959a2bf3838a82e204291a231dd57961c56cfe07b3b98c65",
         intel: "05eb8c4248015af6c6a63498770fa2d7e912a6764fab6af49ff079a83520da68"

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