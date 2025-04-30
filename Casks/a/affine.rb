cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.21.5"
  sha256 arm:   "14b788d77d46767793851debc493c132343fd0d58906638f9e7653e826994b88",
         intel: "ee31fbe3cea9891f3118243669749626fab26cf46c77f344d8fb6d4c6fcfb619"

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