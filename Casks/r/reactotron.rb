cask "reactotron" do
  arch arm: "-arm64"

  version "3.5.0"
  sha256 arm:   "945fdeb613a2655cf5ecba8178de60b6d4a994bbd19defa1847d964bd6629dc3",
         intel: "80b845a8c8a567b7137911de3ee50b80bd55bb3f577acbd15d4593aa271eba81"

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