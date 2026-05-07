cask "heptabase" do
  arch arm: "-arm64"

  version "1.93.0"
  sha256 arm:   "0cff50e5cd6677677c11fb01d4732284eaad1ff1c2a3d89d80457d7a21f13f54",
         intel: "ff6b6ebfcf70b9f5e93a66791aabacc83dc492a22422a50d446a2c2be78673e7"

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