cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.16.0"
  sha256 arm:   "308e55a985bd210afb45a6edb8ad71759d1bbdb993b2a930e8962fc315d1b6fb",
         intel: "d27aa85d4e75302cc2de6d5477b949dad460a44005986124efbfcf7bc9f224e7"

  url "https:github.comtoeverythingAFFiNEreleasesdownloadv#{version}affine-#{version}-stable-macos-#{arch}.zip",
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