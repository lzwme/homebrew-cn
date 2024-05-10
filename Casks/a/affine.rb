cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.14.2"
  sha256 arm:   "6c0648fd27220c674966a8bf678f41fe1ab8703ffe465aadbf3700ecef110a3b",
         intel: "235564134eabc2810119374807079268cd109d1ee5b3d996f27756a6c14a50a2"

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