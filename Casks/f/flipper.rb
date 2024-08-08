cask "flipper" do
  arch arm: "aarch64", intel: "x64"

  version "0.262.0"
  sha256 arm:   "3070404a7aebea3b3aa4733ebe7fd792a6d9de4fde35ac9c495d163185a30805",
         intel: "ed47137a67f3443028cbda49d710bf73c7dd2e59bc40d069f258fa0ee054a175"

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