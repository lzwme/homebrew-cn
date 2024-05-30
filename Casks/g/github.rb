cask "github" do
  arch arm: "arm64", intel: "x64"
  platform = on_arch_conditional arm: "darwin-arm64", intel: "darwin"

  version "3.4.0-bd8f79d7"
  sha256 arm:   "c943345bc92a980c295084f23dea699f74adea090407c897ad1d53fd6da950d4",
         intel: "ebf93033e7cfb9a40f61d432625467cc7f09cfc1f31fca00811b49a9faf9d58c"

  url "https:desktop.githubusercontent.comgithub-desktopreleases#{version}GitHubDesktop-#{arch}.zip",
      verified: "desktop.githubusercontent.comgithub-desktop"
  name "GitHub Desktop"
  desc "Desktop client for GitHub repositories"
  homepage "https:desktop.github.com"

  livecheck do
    url "https:central.github.comdeploymentsdesktopdesktoplatest#{platform}"
    regex(%r{(\d+(?:\.\d+)[^]*)GitHubDesktop[._-]#{arch}\.zip}i)
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "github@beta"

  app "GitHub Desktop.app"
  binary "#{appdir}GitHub Desktop.appContentsResourcesappstaticgithub.sh", target: "github"

  zap trash: [
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.GitHubClient.sfl*",
        "~LibraryApplication Supportcom.github.GitHubClient",
        "~LibraryApplication Supportcom.github.GitHubClient.ShipIt",
        "~LibraryApplication SupportGitHub Desktop",
        "~LibraryApplication SupportShipIt_stderr.log",
        "~LibraryApplication SupportShipIt_stdout.log",
        "~LibraryCachescom.github.GitHubClient",
        "~LibraryCachescom.github.GitHubClient.ShipIt",
        "~LibraryHTTPStoragescom.github.GitHubClient",
        "~LibraryLogsGitHub Desktop",
        "~LibraryPreferencesByHostcom.github.GitHubClient.ShipIt.*.plist",
        "~LibraryPreferencescom.github.GitHubClient.helper.plist",
        "~LibraryPreferencescom.github.GitHubClient.plist",
        "~LibrarySaved Application Statecom.github.GitHubClient.savedState",
      ],
      rmdir: "~.configgit"
end