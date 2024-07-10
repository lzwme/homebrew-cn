cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.15.4"
  sha256 arm:   "ac832748b0caf274eb73d3145edf736b584c11771c37d4880c73a28d5c79ffff",
         intel: "99b5df6e10768ac32eb6951f5a9fcde227147ab9bea14dc0f0aad85503e8b4f3"

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