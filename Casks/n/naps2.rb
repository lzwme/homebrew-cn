cask "naps2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "7.4.2"
  sha256 arm:   "a51e433a4d61ffc6eca998d7abeead0b0117d7d0d1b8f0ebc82f8f487d1f7ded",
         intel: "a2e4ca6c1083f2772dd00f5eca50eb11dc270b8f4a2dd2bcfdd873ae3a56dbf8"

  url "https:github.comcyanfishnaps2releasesdownloadv#{version}naps2-#{version}-mac-#{arch}.pkg",
      verified: "github.comcyanfishnaps2"
  name "NAPS2"
  desc "Document scanning application"
  homepage "https:www.naps2.com"

  depends_on macos: ">= :catalina"

  pkg "naps2-#{version}-mac-#{arch}.pkg"

  uninstall pkgutil: "com.naps2.desktop"

  zap trash: [
    "~.configNAPS2",
    "~LibraryPreferencescom.naps2.desktop.plist",
    "~LibrarySaved Application Statecom.naps2.desktop.savedState",
  ]
end