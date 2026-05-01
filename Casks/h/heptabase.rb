cask "heptabase" do
  arch arm: "-arm64"

  version "1.92.0"
  sha256 arm:   "65e037bc83f4f0c7d84e6f9fda3636aebde15316e6bfd2ed294db1fd4c2591f9",
         intel: "99322e1b5c819e2b91d4b8e68ad62e7ec24c75c4f4e51590821506cb66d206f0"

  url "https://ghfast.top/https://github.com/heptameta/project-meta/releases/download/v#{version}/Heptabase-#{version}#{arch}-mac.zip",
      verified: "github.com/heptameta/project-meta/"
  name "Hepta"
  desc "Note-taking tool for visual learning"
  homepage "https://heptabase.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Heptabase.app"

  zap trash: [
    "~/Library/Preferences/app.projectmeta.projectmeta.plist",
    "~/Library/Saved Application State/app.projectmeta.projectmeta.savedState",
  ]
end