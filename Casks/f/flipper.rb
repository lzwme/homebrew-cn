cask "flipper" do
  arch arm: "aarch64", intel: "x64"

  version "0.259.0"
  sha256 arm:   "a4e01d054dda438c5783f17c8360481ed212a55b4e84f407a94291200b8ba88a",
         intel: "4831b4defcb457758c1284fc685a32b75b15f64b332a4f601fa12b209c42a85a"

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