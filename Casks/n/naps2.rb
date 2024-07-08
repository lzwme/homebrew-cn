cask "naps2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "7.4.3"
  sha256 arm:   "0e6877fabd819b888e7db0dec0db3f376eef219496a7a7bca46977897209b3d0",
         intel: "65d6321e5d987a8b89a9a30b09184740c97191616611fae2e755fcdd33f2606b"

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