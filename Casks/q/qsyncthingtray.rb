cask "qsyncthingtray" do
  version "0.5.8"
  sha256 "1a8bf6975d5f9b1952edf1a070e35338d2c0f6ff9939e3dcda742280baa645b1"

  url "https://ghfast.top/https://github.com/sieren/QSyncthingTray/releases/download/#{version}/QSyncthingTray_#{version}_MAC.dmg"
  name "QSyncthingTray"
  desc "Tray app for Syncthing"
  homepage "https://github.com/sieren/QSyncthingTray"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-28", because: :unmaintained

  app "QSyncthingTray.app"

  zap trash: "~/Library/Preferences/com.sieren.QSyncthingTray.plist"

  caveats do
    requires_rosetta
  end
end