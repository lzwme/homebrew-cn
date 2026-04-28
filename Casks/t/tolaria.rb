cask "tolaria" do
  arch arm: "Silicon", intel: "Intel"

  version "2026.4.27"
  sha256 arm:   "2755e88cfc8109ca21d497ed7f29f48698080b7b6a4dfce24ef0450bc7fc97a0",
         intel: "10a3f220fbc290fcec96d5e1aa1e58e61721a1ced64598bfc58158f70c0fa218"

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