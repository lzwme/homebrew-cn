cask "github@beta" do
  arch arm: "arm64", intel: "x64"
  platform = on_arch_conditional arm: "darwin-arm64", intel: "darwin"

  version "3.4.20-beta1-c76eaed6"
  sha256 arm:   "91a1d53f629e41387078ad7fd7ffc487a8329431acf32167c453d8ad1e4a3b04",
         intel: "765e6c27e262826e83f29ad9f011fb9af57e47634deff5d11c678d02dae6a738"

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