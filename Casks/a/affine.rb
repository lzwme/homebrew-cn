cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.21.4"
  sha256 arm:   "2d836ebd0892e340d294b66c15879707749e08e71847e235d203a55fc363e2d2",
         intel: "3484566d570c57b5975c37c61840dfba011a935bce2339dcb1a6b7304dbfde3d"

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