cask "flipper" do
  arch arm: "aarch64", intel: "x64"

  version "0.273.0"
  sha256 arm:   "9b477dbae27651166b76a7ff06995c8da99ceece48ba12d0bdaf7e23e9b3eb53",
         intel: "4fb255b22728eeb7a670bf795686f767c16c988c586c656fbc6c37b8de896b42"

  url "https:github.comfacebookflipperreleasesdownloadv#{version}Flipper-server-mac-#{arch}.dmg",
      verified: "github.comfacebookflipper"
  name "Facebook Flipper"
  desc "Desktop debugging platform for mobile developers"
  homepage "https:fbflipper.com"

  deprecate! date: "2024-12-01", because: :discontinued

  app "Flipper.app"

  zap trash: [
    "~.flipper",
    "~LibraryApplication SupportFlipper",
    "~LibraryPreferencesrs.flipper-launcher",
  ]
end