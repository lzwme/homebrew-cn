cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.21.2"
  sha256 arm:   "5bcad41d5cf071abee060ab2880ddfe2ca0ad00fbf8fadc29da61b9e5a3a8da6",
         intel: "408d1e0dd522ed426288719e5d144f4b4da7adb9794261c37f5d295f4c4b0fb7"

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