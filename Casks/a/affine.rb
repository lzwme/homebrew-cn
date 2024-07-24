cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.15.7"
  sha256 arm:   "7c388574a89b89a57c34351fb07aed0c974bfd8b0ba7203e5398883f973026be",
         intel: "b10cb7b5af505096e44da34c4e536adc332ab92b52d1b9f2c964e3c440836cd0"

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