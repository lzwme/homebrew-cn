cask "katalon-studio" do
  arch arm: "%20Arm64"

  version "10.2.3"
  sha256 arm:   "301ec470cc20f048ce5182ccb0f53143471f9fd479510cac12762fa6ddff04d1",
         intel: "b02db5ef720af4dc3d9a0423e7f7f421d4078691327c69816f0d3595a36a9c41"

  url "https:download.katalon.comfree#{version}releaseKatalon%20Studio#{arch}.dmg"
  name "Katalon Studio"
  desc "Test automation solution"
  homepage "https:katalon.comdownload"

  livecheck do
    url "https:github.comkatalon-studiokatalon-studio"
    regex(^free[._-]v?(\d+(?:\.\d+)+)$i)
  end

  app "Katalon Studio.app"

  zap trash: [
    "~.katalon",
    "~LibraryPreferencescom.kms.katalon.product.product.plist",
    "~LibrarySaved Application Statecom.kms.katalon.product.product.savedState",
  ]
end