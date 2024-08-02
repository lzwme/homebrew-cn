cask "flipper" do
  arch arm: "aarch64", intel: "x64"

  version "0.261.0"
  sha256 arm:   "3af66cd7c509b1ee2eec0966fc520726877aa74900822bf0b050f575a4cfa961",
         intel: "000c9a1cbe1c94ed1ac8094fa2aab59630e53302179f1d070550832ce7c0c6a5"

  url "https:github.comfacebookflipperreleasesdownloadv#{version}Flipper-server-mac-#{arch}.dmg",
      verified: "github.comfacebookflipper"
  name "Facebook Flipper"
  desc "Desktop debugging platform for mobile developers"
  homepage "https:fbflipper.com"

  livecheck do
    url "https:www.facebook.comfbflipperpubliclatest.json?version=0.0.0"
    strategy :json do |json|
      json["version"]
    end
  end

  app "Flipper.app"

  zap trash: [
    "~.flipper",
    "~LibraryApplication SupportFlipper",
    "~LibraryPreferencesrs.flipper-launcher",
  ]
end