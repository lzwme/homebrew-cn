cask "github" do
  arch arm: "arm64", intel: "x64"
  platform = on_arch_conditional arm: "darwin-arm64", intel: "darwin"

  version "3.3.14-b6c1402e"
  sha256 arm:   "1195878e7d27b18d63706e4a8cf76ea3d471278142578b27b3680ab9eece81f2",
         intel: "79dd7a600c1598cbf32603570aed72a57a3f52495bff30f795e401256bf4352b"

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