cask "citra" do
  version "2.0"
  sha256 "ecfdcfb89b8c961fe1b68313121d2af37370b43af38e9bcd16cccc162ab121ec"

  url "https://ghfast.top/https://github.com/citra-emu/citra-web/releases/download/#{version}/citra-setup-mac.dmg",
      verified: "github.com/citra-emu/citra-web/"
  name "Citra"
  desc "Nintendo 3DS emulator"
  homepage "https://citra-emu.org/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-25", because: :discontinued
  disable! date: "2025-06-25", because: :discontinued

  installer manual: "citra-setup-mac.app"

  uninstall delete: "/Applications/Citra"

  zap trash: [
    "~/Library/Preferences/com.citra-emu.citra.plist",
    "~/Library/Saved Application State/com.citra-emu.citra.savedState",
  ]
end