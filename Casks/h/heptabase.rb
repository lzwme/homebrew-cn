cask "heptabase" do
  arch arm: "-arm64"

  version "1.84.2"
  sha256 arm:   "bf8cca5539103b3f79ebab9944f1e290ea60f9654fd375ca60a6c3263bb5932f",
         intel: "46639f68c71c6a999e5fa7b64564da52854206c7d4acaafdee97df666308096b"

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