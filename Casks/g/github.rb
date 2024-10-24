cask "github" do
  arch arm: "arm64", intel: "x64"
  platform = on_arch_conditional arm: "darwin-arm64", intel: "darwin"

  on_mojave :or_older do
    version "3.3.13-1b0804db"
    sha256 "df85436557e7b3d709cc702b751f180f48655a3241cce6a864e55cf5161d9a7a"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    version "3.4.8-e3aa0782"
    sha256 arm:   "1ca13b7da2bbd3100e8017035d267561dde650a6dbb757461b2a8decbb4bcae9",
           intel: "971fbe3aabc683ba963379b6be9e87ae994e0e34e9dd67cfec663f44da38fddc"

    livecheck do
      url "https:central.github.comdeploymentsdesktopdesktoplatest#{platform}"
      regex(%r{(\d+(?:\.\d+)[^]*)GitHubDesktop[._-]#{arch}\.zip}i)
      strategy :header_match
    end
  end

  url "https:desktop.githubusercontent.comreleases#{version}GitHubDesktop-#{arch}.zip",
      verified: "desktop.githubusercontent.com"
  name "GitHub Desktop"
  desc "Desktop client for GitHub repositories"
  homepage "https:desktop.github.com"

  auto_updates true
  conflicts_with cask: "github@beta"
  depends_on macos: ">= :high_sierra"

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