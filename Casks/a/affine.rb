cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.17.2"
  sha256 arm:   "ea4645f93c0493045d47e0e8975f23e52fbf323790087ecc1de710a4495c5c38",
         intel: "c075acc01cda0c1712b9085ef535af91fde100fc7d0acb079477634406229553"

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