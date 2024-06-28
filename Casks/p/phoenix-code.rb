cask "phoenix-code" do
  arch arm: "aarch64", intel: "x64"

  version "3.8.8"
  sha256 arm:   "5e22f890b090ff3313d58a47f0b7efc616855bcbf98d8d487f8cffa71db451f2",
         intel: "0b22b912b44ba4cfd41dfef26839ce86111621107ea9c37ef87ec1bfb60f37eb"

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