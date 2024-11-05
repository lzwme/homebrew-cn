cask "rize" do
  arch arm: "arm64", intel: "x64"

  version "1.5.1"
  sha256  arm:   "3d16d4b3949190c224a261c2e753d6a8d8f732aa10679b6f6cbe3b06090545e0",
          intel: "74299843b4751f3c5f12b19694698378d973bcbae01e7c0918c23f8b38b21499"

  url "https:github.comrize-ioluareleasesdownloadv#{version}Rize-#{version}-#{arch}.dmg",
      verified: "github.comrize-iolua"
  name "Rize"
  desc "AI time tracker"
  homepage "https:rize.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Rize.app"

  zap trash: [
    "~LibraryApplication SupportRize",
    "~LibraryCachesio.rize",
    "~LibraryCachesio.rize.ShipIt",
    "~LibraryHTTPStoragesio.rize",
    "~LibraryPreferencesio.rize.plist",
    "~LibrarySaved Application Stateio.rize.savedState",
  ]
end