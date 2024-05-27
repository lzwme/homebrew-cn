cask "phoenix-code" do
  arch arm: "aarch64", intel: "x64"

  version "3.7.3"
  sha256 arm:   "c8b4ae5b6b1d9cd6c648dbe4d6be59c3433c8b9b24e2d587c3a6b91361b91308",
         intel: "0e6e94db88f6bd11e67bc05bfb0294303db9bc3973cddf42a2f6bc23c4514112"

  url "https:github.comphcode-devphoenix-desktopreleasesdownloadprod-app-v#{version}Phoenix.Code_#{version}_#{arch}.dmg",
      verified: "github.comphcode-devphoenix-desktop"
  name "Phoenix Code"
  desc "Code editor"
  homepage "https:phcode.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Phoenix Code.app"

  zap trash: [
        "~LibraryApplication Supportio.phcode",
        "~LibraryCachesio.phcode",
        "~LibrarySaved Application Stateio.phcode.savedState",
        "~LibraryWebKitio.phcode",
      ],
      rmdir: "~DocumentsPhoenix Code"
end