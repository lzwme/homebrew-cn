cask "heptabase" do
  arch arm: "-arm64"

  version "1.84.0"
  sha256 arm:   "1df9704b9e3d41a41722d7cef4428d15df67f3e7fdde1a823e6fc900d19738c3",
         intel: "e6c8f89174b688da4aacfa1d439ad88fb3eb70cc6c6e261140abd4e2255ae517"

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