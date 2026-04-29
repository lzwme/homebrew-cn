cask "tolaria" do
  arch arm: "Silicon", intel: "Intel"

  version "2026.4.28"
  sha256 arm:   "c91cc187f3301377bf6d7a7cd23555728253446d8fbb541269e41044f648b81e",
         intel: "4c038edbbe7f366fbeda9b7944ef22bcef0cbd915466068ca4219a7eaa78d653"

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