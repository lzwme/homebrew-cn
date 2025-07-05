cask "pixel-picker" do
  version "1.6.1"
  sha256 "2c98627f6fca2f3a7d043499e63be25dd80ecd6ab848e15637961f10ebc0bd6f"

  url "https://ghfast.top/https://github.com/acheronfail/pixel-picker/releases/download/#{version}/Pixel.Picker.#{version}.dmg"
  name "Pixel Picker"
  desc "Menu bar application to pick colours from your screen"
  homepage "https://github.com/acheronfail/pixel-picker"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Pixel Picker.app"

  zap trash: [
    "~/Library/Logs/Pixel Picker",
    "~/Library/Preferences/Pixel Picker",
  ]
end