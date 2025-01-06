cask "scrolla" do
  version "20"
  sha256 :no_check

  url "https://scrolla.app/releases/Scrolla.zip"
  name "Scrolla"
  desc "Scroll with the keyboard using Vim motions"
  homepage "https://scrolla.app/"

  livecheck do
    url "https://scrolla.app/releases/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :ventura"

  app "Scrolla.app"

  zap trash: [
    "~/Library/Application Scripts/mo.com.sleeplessmind.Scrolla",
    "~/Library/Application Scripts/mo.com.sleeplessmind.Scrolla-LaunchAtLoginHelper",
    "~/Library/Application Support/Scrolla",
    "~/Library/Caches/mo.com.sleeplessmind.Scrolla",
    "~/Library/Containers/mo.com.sleeplessmind.Scrolla",
    "~/Library/Containers/mo.com.sleeplessmind.Scrolla-LaunchAtLoginHelper",
    "~/Library/Preferences/mo.com.sleeplessmind.Scrolla.plist",
    "~/Library/Saved Application State/mo.com.sleeplessmind.Scrolla.savedState",
  ]
end