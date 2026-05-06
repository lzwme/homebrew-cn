cask "repobar" do
  version "0.4.2"
  sha256 "e854583b1bcbf5dcc5398ee0cccb5169b94543f079c3242ab176de8cca5a6429"

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