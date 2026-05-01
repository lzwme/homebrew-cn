cask "tolaria" do
  arch arm: "Silicon", intel: "Intel"

  version "2026.4.30"
  sha256 arm:   "ea3dd75e8c085e0495d0dd5d47d4281a3aac48744e37cad8a1fc9780a83195d3",
         intel: "cb9274bd6bbd80808af3ec730a362fa603d1151c5b9c03f20b7069dcdd222ac8"

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