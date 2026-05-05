cask "pomotroid" do
  version "1.7.0"
  sha256 "ce14f75b79a8606165bdf181afe0b4703158a232854a4172842fbc69b84d7cb4"

  url "https://ghfast.top/https://github.com/Splode/pomotroid/releases/download/v#{version}/Pomotroid_#{version}_universal.dmg"
  name "Pomotroid"
  desc "Timer application"
  homepage "https://github.com/Splode/pomotroid"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on :macos

  app "Pomotroid.app"

  zap trash: [
    "~/Library/Application Support/pomotroid",
    "~/Library/Preferences/com.splode.pomotroid.plist",
    "~/Library/Saved Application State/com.splode.pomotroid.savedState",
  ]
end