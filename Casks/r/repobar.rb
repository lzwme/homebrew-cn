cask "repobar" do
  version "0.4.0"
  sha256 "7e3674518a2727123fc607522607cf8146bca757f5f817f210259a5914e1a1f4"

  url "https://ghfast.top/https://github.com/steipete/RepoBar/releases/download/v#{version}/RepoBar-#{version}.zip",
      verified: "github.com/steipete/RepoBar/"
  name "RepoBar"
  desc "Menu bar dashboard for GitHub repository health"
  homepage "https://repobar.app/"

  depends_on macos: ">= :sequoia"

  app "RepoBar.app"

  zap trash: [
    "~/Library/Application Support/com.steipete.repobar",
    "~/Library/Application Support/RepoBar",
    "~/Library/Caches/com.steipete.repobar",
    "~/Library/Caches/RepoBar",
    "~/Library/HTTPStorages/com.steipete.repobar",
    "~/Library/Preferences/com.steipete.repobar.plist",
    "~/Library/Saved Application State/com.steipete.repobar.savedState",
  ]
end