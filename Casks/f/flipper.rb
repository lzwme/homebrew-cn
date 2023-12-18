cask "flipper" do
  version "0.239.0"
  sha256 "192dc10ae4017c223074b89c5581326c26dde215f29e53bb6547a44c9898464c"

  url "https:github.comfacebookflipperreleasesdownloadv#{version}Flipper-mac.dmg",
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