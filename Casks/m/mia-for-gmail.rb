cask "mia-for-gmail" do
  version "2.7.2"
  sha256 "fa4218668d953287f2943e2b488ad85aac93075173bcccf6e00ff6c1bfb24369"

  url "http://www.sovapps.com/application/notifier-pro-for-gmail/mia.#{version}.zip",
      verified: "sovapps.com/application/notifier-pro-for-gmail/"
  name "Mia for Gmail"
  desc "Desktop email client for Gmail"
  homepage "http://www.miaforgmail.com/"

  livecheck do
    url "http://www.sovapps.com/application/notifier-pro-for-gmail/notifier.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true

  app "Mia for Gmail.app"

  uninstall quit: "com.sovapps.gmailnotifier"

  zap trash: [
    "~/Library/Application Scripts/com.sovapps.gmailnotifier",
    "~/Library/Application Scripts/com.sovapps.launchAtLoginHelper",
    "~/Library/Caches/com.sovapps.gmailnotifier",
    "~/Library/Containers/com.sovapps.launchAtLoginHelper",
    "~/Library/Preferences/com.sovapps.gmailnotifier.plist",
  ]
end