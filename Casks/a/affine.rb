cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.19.6"
  sha256 arm:   "70c1dc62d90d12152603ce447e7e8d67a57d5dbecccb1dbf280d09bce25bad7e",
         intel: "cd177fcebf5b767ec334fce4712f2ee170932e90ab1f83baea1c0665e0c7c9b8"

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