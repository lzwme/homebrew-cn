cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.14.4"
  sha256 arm:   "ad1780c138901a791b35f488dcb20bb413f28607846fa4b8f6ea73eda24f02fa",
         intel: "4939e746fee4debee1781d7bbf47a88e4ae9deab445565acf56d04a8342c76d9"

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