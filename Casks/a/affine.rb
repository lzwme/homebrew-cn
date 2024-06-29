cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.15.0"
  sha256 arm:   "7fbdeb260998481e15d7433d9aa81c06379ef7dace76ee731d2c2eaf40f0f144",
         intel: "9b6f3c6f938568c354b7f74d4e4091db4f7d3b51a0a05bfdc8531c09a7d22e2e"

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