cask "naps2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "7.5.2"
  sha256 arm:   "b919da17a5eb6ae5273d714a48ff61f0d65496047d63303b1f8561635b508b9d",
         intel: "16c0e2f629a92b9ad5f4340dd56abab937b92f343600f1ce6230c547a8ead9a6"

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