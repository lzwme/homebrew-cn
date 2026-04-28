cask "pomotroid" do
  version "1.6.0"
  sha256 "e5a045067a5d90c4e17ee674a4efa96d5c9474653d15bd3b275236cdec48d8e2"

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