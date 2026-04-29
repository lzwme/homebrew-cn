cask "boltai" do
  version "2.11.0"
  sha256 "806ad575abdb493bff0a2c2e6867abf024f01708e3d3c85989d9be96a8c4cb36"

  url "https://updates.boltai.com/dmg/BoltAI-#{version}.dmg"
  name "BoltAI 2"
  desc "AI chat client"
  homepage "https://boltai.com/"

  livecheck do
    url "https://updates.boltai.com/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "BoltAI #{version.major}.app"

  zap trash: [
    "~/Library/Application Scripts/co.podzim.boltai-mobile",
    "~/Library/Containers/co.podzim.boltai-mobile",
    "~/Library/Saved Application State/co.podzim.boltai-mobile.savedState",
  ]
end