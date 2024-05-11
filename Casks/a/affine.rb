cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.14.3"
  sha256 arm:   "d7af5e1a74ca79c1bcaac7db938bc6e22727ea1701bb484c27d94e7452e5d475",
         intel: "d898b84e62e29d7f32dbed39e7623bf2af89b6ad09c1b5ca5e41f7ed88467306"

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