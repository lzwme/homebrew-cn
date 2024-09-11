cask "phoenix-code" do
  arch arm: "aarch64", intel: "x64"

  version "3.9.4"
  sha256 arm:   "458c01fb1dcee88b087436902ea5b574d360517fc5c39dc0e12647002de5b956",
         intel: "d45ab1c10a97f02557d98e1d371a154ce294fac497b8effe48f122713bc5a3fa"

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