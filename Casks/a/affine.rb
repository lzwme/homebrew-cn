cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.17.0"
  sha256 arm:   "2585bd23662ac2e9edfb547fc2c0b7495e8bc800bdddba9f97949d996f15652d",
         intel: "29fa716001d9c8b6bf7ad03ed30caafe5e3fb14ae6b36201dbc56af14db9a8e2"

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