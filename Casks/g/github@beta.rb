cask "github@beta" do
  arch arm: "arm64", intel: "x64"
  platform = on_arch_conditional arm: "darwin-arm64", intel: "darwin"

  version "3.4.4-beta1-83dec9ec"
  sha256 arm:   "a2456ada0ca13a52e1489cf80d7e1ada64be477de7b8b6635a063f2c87cc084f",
         intel: "59033d634e54e263f909ae4af0b3cfd5710d22690344317dffaa8b5ec4ce276b"

  url "https:desktop.githubusercontent.comreleases#{version}GitHubDesktop-#{arch}.zip",
      verified: "desktop.githubusercontent.com"
  name "GitHub Desktop"
  desc "Desktop client for GitHub repositories"
  homepage "https:desktop.github.com"

  livecheck do
    url "https:central.github.comdeploymentsdesktopdesktoplatest#{platform}?env=beta"
    regex(%r{(\d+(?:\.\d+)[^]*)GitHubDesktop[._-]#{arch}\.zip}i)
    strategy :header_match
  end

  auto_updates true
  conflicts_with cask: "github"
  depends_on macos: ">= :catalina"

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
        "~LibraryLogsGitHub Desktop",
        "~LibraryPreferencesByHostcom.github.GitHubClient.ShipIt.*.plist",
        "~LibraryPreferencescom.github.GitHubClient.helper.plist",
        "~LibraryPreferencescom.github.GitHubClient.plist",
      ],
      rmdir: "~.configgit"
end