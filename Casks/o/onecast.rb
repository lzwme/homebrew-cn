cask "onecast" do
  version "3.2.3"
  sha256 "ffa22d95720aa54640771d31201a6b1a7af8240af9f35d9cb2602da42868542f"

  url "https://onecast.me/updates/release/OneCast-#{version}.dmg"
  name "OneCast"
  desc "Xbox remote play"
  homepage "https://www.onecast.me/"

  livecheck do
    url "https://www.onecast.me/updates/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "OneCast.app"

  zap trash: [
    "~/Library/Caches/com.onecast.macos",
    "~/Library/HTTPStorages/com.onecast.macos",
    "~/Library/Preferences/com.onecast.macos.plist",
    "~/Library/WebKit/com.onecast.macos",
  ]
end