cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.11.0"
  sha256 arm:   "3bc55951dd8a6b7400fcd202ae32ce4000833e03aa019a0ff5e53e88b4968ff1",
         intel: "e31dcce5aba56100b52a5ae1c8ce8a9a34ab6ed608d3d7c336ad710fba8fdd88"

  url "https:github.comtoeverythingAFFiNEreleasesdownloadv#{version}affine-stable-macos-#{arch}.zip",
      verified: "github.comtoeverythingAFFiNE"
  name "AFFiNE"
  desc "Note editor and whiteboard"
  homepage "https:affine.pro"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "AFFiNE.app"

  zap trash: [
    "~LibraryApplication SupportAFFiNE",
    "~LibraryLogsAFFiNE",
    "~LibraryPreferencespro.affine.app.plist",
    "~LibrarySaved Application Statepro.affine.app.savedState",
  ]
end