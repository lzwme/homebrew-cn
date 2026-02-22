cask "nostalgiapp" do
  version "1.0.4"
  sha256 "65911652533a1f38e77531a28229a85fea17a2bd47483f5dd294f510acbaadad"

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