cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.20.2"
  sha256 arm:   "961113935949109077fcd06eddccd4b775e370ef3b388d88e6f61b7b68fc5d7e",
         intel: "56905707d2a98f80a7ccc5088c1eb7e2e1a22fd5b94a77299af25e046ba3812c"

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