cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.21.1"
  sha256 arm:   "e1e32a13e1c8969ce679a633f4af71ddc0fd3d3a82e70bcee7bbdc9bebe38bd0",
         intel: "0a9e09943647962c9440d2b1f26e6aef745f252918bc52ea8589103e25e613df"

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