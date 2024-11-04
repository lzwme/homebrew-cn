cask "wooshy" do
  version "29"
  sha256 :no_check

  url "https://wooshy.app/releases/Wooshy.zip"
  name "Wooshy"
  desc "Click and more on UI Elements through typing"
  homepage "https://wooshy.app/"

  livecheck do
    url "https://wooshy.app/releases/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :monterey"

  app "Wooshy.app"

  zap login_item: "Wooshy",
      trash:      [
        "~/Library/Application Scripts/mo.com.sleeplessmind.Wooshy*",
        "~/Library/Application Support/Wooshy",
        "~/Library/Caches/mo.com.sleeplessmind.Wooshy",
        "~/Library/Containers/mo.com.sleeplessmind.Wooshy*",
        "~/Library/HTTPStorages/mo.com.sleeplessmind.Wooshy*",
        "~/Library/Preferences/mo.com.sleeplessmind.Wooshy.plist",
        "~/Library/Saved Application State/mo.com.sleeplessmind.Wooshy.savedState",
      ]
end