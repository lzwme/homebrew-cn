cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.14.1"
  sha256 arm:   "23ef8399421c436311db50f524616b766c51834de4d60b60e216d373a72b3c44",
         intel: "417caa31f2a4b12464cb6fea7ea8e01cc3fe742582472ee0e3425c696f3f577e"

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