cask "naps2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "8.1.1"
  sha256 arm:   "6f85405dff5bb44658eec50af772733c5d6fcadc11ba82d91bbd9aee8f71f43e",
         intel: "745d57bcb6a88b2521f463a266a636fa36e52b4f5b5c9797e7b311e75803cd2e"

  url "https:github.comcyanfishnaps2releasesdownloadv#{version}naps2-#{version}-mac-#{arch}.pkg",
      verified: "github.comcyanfishnaps2"
  name "NAPS2"
  desc "Document scanning application"
  homepage "https:www.naps2.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  pkg "naps2-#{version}-mac-#{arch}.pkg"

  uninstall pkgutil: "com.naps2.desktop"

  zap trash: [
    "~.configNAPS2",
    "~LibraryPreferencescom.naps2.desktop.plist",
    "~LibrarySaved Application Statecom.naps2.desktop.savedState",
  ]
end