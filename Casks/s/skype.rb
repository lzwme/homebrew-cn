cask "skype" do
  version "8.115.0.215"
  sha256 "f6a3296483fac4404af1055a7f128a930fd312138ae39acde45fb35b1dcb66db"

  url "https://endpoint920510.azureedge.net/s4l/s4l/download/mac/Skype-#{version}.dmg",
      verified: "endpoint920510.azureedge.net/s4l/s4l/download/mac/"
  name "Skype"
  desc "Video chat, voice call and instant messaging application"
  homepage "https://www.skype.com/"

  livecheck do
    url "https://go.skype.com/mac.download"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Skype.app"

  zap trash: [
    "~/Library/Address Book Plug-Ins/SkypeABCaller.bundle",
    "~/Library/Address Book Plug-Ins/SkypeABChatter.bundle",
    "~/Library/Address Book Plug-Ins/SkypeABDialer.bundle",
    "~/Library/Address Book Plug-Ins/SkypeABSMS.bundle",
    "~/Library/Application Scripts/com.skype.skype.shareagent",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.skype.skype.sfl*",
    "~/Library/Application Support/CrashReporter/Skype_*.plist",
    "~/Library/Application Support/Microsoft/Skype for Desktop",
    "~/Library/Application Support/Skype Helper",
    "~/Library/Application Support/Skype",
    "~/Library/Application Support/T/SkypeRT",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.skype.skype",
    "~/Library/Caches/com.skype.skype",
    "~/Library/Caches/com.skype.skype.ShipIt",
    "~/Library/Containers/com.skype.skype.shareagent",
    "~/Library/Cookies/com.skype.skype.binarycookies",
    "~/Library/Group Containers/*.com.skype.skype",
    "~/Library/Preferences/ByHost/com.skype.skype.*.plist",
    "~/Library/Preferences/com.skype.skype.plist",
    "~/Library/Preferences/com.skype.skypewifi.plist",
    "~/Library/Saved Application State/com.skype.skype.savedState",
    "~/Library/WebKit/com.skype.skype",
  ]
end