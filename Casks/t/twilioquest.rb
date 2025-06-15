cask "twilioquest" do
  version "8.0.0"
  sha256 :no_check

  url "https://firebasestorage.googleapis.com/v0/b/twilioquest-prod.appspot.com/o/launchers%2F8%2Ftwilioquest-mac.zip?alt=media",
      verified: "firebasestorage.googleapis.com/v0/b/twilioquest-prod.appspot.com/"
  name "TwilioQuest"
  desc "Learn to code and lead your crew on a mission to save The Cloud in a 16bit game"
  homepage "https://www.twilio.com/quest"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "TwilioQuest.app"

  uninstall pkgutil: [
    "com.electron.twilioquest",
    "com.electron.twilioquest.helper",
  ]

  zap trash: [
    "~/Library/Application Support/TwilioQuest",
    "~/Library/Preferences/com.electron.twilioquest.plist",
    "~/Library/Saved Application State/com.electron.twilioquest.savedState",
  ]
end