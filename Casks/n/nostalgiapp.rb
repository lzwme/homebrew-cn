cask "nostalgiapp" do
  version "1.0.8.8.4"
  sha256 "61fd9fb49f575307eee983a049b86a79c26637990c89d5374ac2a7ba5565aa0d"

  url "https://www.nostalgi.app/downloads/NostalgiApp-#{version}.dmg"
  name "NostalgiApp"
  desc "Launcher for eXoDOS and retro game collections"
  homepage "https://nostalgi.app/"

  livecheck do
    url "https://nostalgi.app/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "NostalgiApp.app"

  zap trash: [
    "~/Library/Application Support/NostalgiApp",
    "~/Library/Caches/com.nostalgi.app",
    "~/Library/Logs/NostalgiApp",
    "~/Library/Preferences/com.nostalgi.app.plist",
  ]
end