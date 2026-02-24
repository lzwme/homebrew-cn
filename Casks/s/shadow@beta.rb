cask "shadow@beta" do
  arch arm: "arm64", intel: "x64"

  version "9.9.10372"
  sha256 arm:   "c6c8f79bf77916e47f6ef0003af6109ffe9a867bcab068ad1e7dfc1530fe6999",
         intel: "9c230fb5b1ce31b0e14eecc566a6cb7824b101292071c39da4a4710ff2af3bbf"

  url "https://update.shadow.tech/launcher/preprod/mac/#{arch}/ShadowPCBeta-#{version}.dmg"
  name "Shadow PC Beta"
  desc "Online virtualized computer"
  homepage "https://shadow.tech/"

  livecheck do
    url "https://update.shadow.tech/launcher/preprod/mac/#{arch}/latest-mac.yml"
    strategy :electron_builder
  end

  app "Shadow PC Beta.app"

  zap trash: [
    "~/Library/Application Support/shadow-preprod",
    "~/Library/Preferences/com.electron.shadow-beta.plist",
  ]
end