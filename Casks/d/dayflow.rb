cask "dayflow" do
  version "1.8.0"
  sha256 "0f7c20cce0fc432d12d7b9c1b362d7489231dfcbd306c5459e6efa6f47487974"

  url "https://ghfast.top/https://github.com/JerryZLiu/Dayflow/releases/download/v#{version}/Dayflow.dmg"
  name "Dayflow"
  desc "Generate a timeline of your day, automatically"
  homepage "https://github.com/JerryZLiu/Dayflow"

  livecheck do
    url "https://jerryzliu.github.io/Dayflow/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Dayflow.app"

  zap trash: [
    "~/Library/Application Scripts/teleportlabs.com.Dayflow",
    "~/Library/Application Support/Dayflow",
    "~/Library/Containers/teleportlabs.com.Dayflow",
  ]
end