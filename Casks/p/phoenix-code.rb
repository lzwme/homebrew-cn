cask "phoenix-code" do
  arch arm: "aarch64", intel: "x64"

  version "4.0.3"
  sha256 arm:   "6eb5238eb6e2bf53b4ec976faf9ae5a035a409dc74776ad56f09eed6020702d2",
         intel: "c88f999d6d51f1a70a8463b6d7f30da97dfc442dac917819dee391a2c201f885"

  url "https:github.comphcode-devphoenix-desktopreleasesdownloadprod-app-v#{version}Phoenix.Code_#{version}_#{arch}.dmg",
      verified: "github.comphcode-devphoenix-desktop"
  name "Phoenix Code"
  desc "Code editor"
  homepage "https:phcode.io"

  livecheck do
    url "https:updates.phcode.iotauriupdate-latest-stable-prod.json"
    strategy :json do |json|
      json["version"]
    end
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