cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.20.4"
  sha256 arm:   "c3a17d398e7b16e4161169feb7176d5dc1387c5e60eaf619e8c0c0071571f4a1",
         intel: "c50b32bcffb0ee36768d9b9acefbabe60ab9d84eec1f73b6935fdeae59749954"

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