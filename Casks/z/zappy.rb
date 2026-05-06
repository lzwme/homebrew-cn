cask "zappy" do
  version "4.9.7"
  sha256 "5a9cd962cc034f1640b9b55ebe88738d6c90703c82f985641deb0ba01d0811b3"

  url "https://zappy.zapier.com/releases/zappy-#{version}.dmg"
  name "Zappy"
  desc "Screen capture tool for remote teams"
  homepage "https://zapier.com/zappy"

  livecheck do
    url "https://zappy.zapier.com/releases/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sequoia"

  app "Zappy.app"

  uninstall quit: "com.blackbeltlabs.Zappy"

  zap trash: [
    "~/Library/Application Support/com.blackbeltlabs.Zappy",
    "~/Library/Caches/com.blackbeltlabs.Zappy",
    "~/Library/Preferences/com.blackbeltlabs.Zappy.plist",
    "~/Library/zappy",
  ]
end