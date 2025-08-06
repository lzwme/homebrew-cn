cask "hammerspoon" do
  on_mojave :or_older do
    version "0.9.93"
    sha256 "eb4eb4b014d51b32ac15f87050eb11bcc2e77bcdbfbf5ab60a95ecc50e55d2a3"

    url "https://github.com/Hammerspoon/hammerspoon/files/7707382/Hammerspoon-#{version}-for-10.14.zip",
        verified: "github.com/Hammerspoon/hammerspoon/"

    # Specific build provided for Mojave upstream https://github.com/Hammerspoon/hammerspoon/issues/3023#issuecomment-992980087
    livecheck do
      skip "Specific build for Mojave and later"
    end
  end
  on_catalina :or_newer do
    version "1.0.0"
    sha256 "5db702b55da47dc306e8f5948d91ef85bebd315ddfa29428322a0af7ed7e6a7e"

    url "https://ghfast.top/https://github.com/Hammerspoon/hammerspoon/releases/download/#{version}/Hammerspoon-#{version}.zip",
        verified: "github.com/Hammerspoon/hammerspoon/"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Hammerspoon/hammerspoon/master/appcast.xml"
      strategy :sparkle, &:short_version
    end
  end

  name "Hammerspoon"
  desc "Desktop automation application"
  homepage "https://www.hammerspoon.org/"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Hammerspoon.app"
  binary "#{appdir}/Hammerspoon.app/Contents/Frameworks/hs/hs"

  uninstall quit: "org.hammerspoon.Hammerspoon"

  zap trash: [
    "~/.hammerspoon",
    "~/Library/Application Support/com.crashlytics/org.hammerspoon.Hammerspoon",
    "~/Library/Caches/org.hammerspoon.Hammerspoon",
    "~/Library/Preferences/org.hammerspoon.Hammerspoon.plist",
    "~/Library/Saved Application State/org.hammerspoon.Hammerspoon.savedState",
  ]
end