cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.16.2"
  sha256 arm:   "9d4aec5a4dcc67d46588b11052342d6e02b40742bc1dc5af8892a1260eeaf977",
         intel: "d3cae0655b32429cf290ab94c8408f640177016aef73c7a8ccf23fb9487e4a2a"

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