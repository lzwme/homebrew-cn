cask "tolaria" do
  arch arm: "Silicon", intel: "Intel"

  version "2026.4.29"
  sha256 arm:   "1dc30016ec0ba1dcdd7ff6928a3a9c886e03b035b56cd8d2c95ef86233170a65",
         intel: "0ce2cb5405f31a718f058e49830dce2050a4cd5804fe8e5d09da68dec5e16208"

  url "https://ghfast.top/https://github.com/refactoringhq/tolaria/releases/download/stable-v#{version}/Tolaria_#{version}_macOS_#{arch}.dmg",
      verified: "github.com/refactoringhq/tolaria/"
  name "Tolaria"
  desc "Markdown knowledgebase manager"
  homepage "https://tolaria.md/"

  livecheck do
    url :url
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on :macos

  app "Tolaria.app"

  zap trash: [
    "~/Library/Application Support/com.tolaria.app",
    "~/Library/Caches/club.refactoring.tolaria",
    "~/Library/Preferences/club.refactoring.tolaria.plist",
    "~/Library/WebKit/club.refactoring.tolaria",
  ]
end