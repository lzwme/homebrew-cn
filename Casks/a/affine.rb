cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.11.1"
  sha256 arm:   "5c45a1c2b5ba216193474d35a7ad74a5fbe350c880a182d9fd10cb11897e6acc",
         intel: "caabb9526586e53cb923685183a56e6af1cb18b44a04b4cbfe4af391539b807f"

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