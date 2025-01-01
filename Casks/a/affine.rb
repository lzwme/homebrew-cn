cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.19.4"
  sha256 arm:   "543be5175d83e5f2d7dfad22f6fd8299590489dfe936200d72007f9b71b3d517",
         intel: "b8bf8468cb286c237f0d4379ac288e176dc7ec3bf60ab0622d1ff7a3e58b73fc"

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