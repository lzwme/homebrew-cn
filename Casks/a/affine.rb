cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.17.4"
  sha256 arm:   "f6b25455747a1f533afcb5bc67b68e9717b56722d38ea135909d14ef37a838be",
         intel: "ac4f7a7f4d510e87d060f6dfc2f69b2d735866316bb47c2e8021338079e9e9cc"

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