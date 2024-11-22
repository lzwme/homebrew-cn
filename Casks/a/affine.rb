cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.18.1"
  sha256 arm:   "124fe5c728f6310ba2ec9d83699d7596aa2d3cc407124514a1c4d16e4418eb1a",
         intel: "c8ad1eb85080334dd3d7fc0a0c6c9626c9b3e6bb771183463fbe7d9e1951ca6f"

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