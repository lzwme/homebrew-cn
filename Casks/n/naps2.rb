cask "naps2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  arch arm: "arm64", intel: "x64"

  version "8.1.3"
  sha256 arm:   "548957b0861c385ca3eae8a00d92a89b6818d1176c792ddb26c6f2ff96204fa4",
         intel: "6e07d30ca1c35b917026e501e276ec5b21976fb40d108cb5e5b4835688217c75"

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