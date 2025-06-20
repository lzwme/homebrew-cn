cask "fuse" do
  version "1.9.0"
  sha256 "31e737086d546176f436a2792baca604487f529008a21c424610baec25146a20"

  url "https:github.comfuse-openfuse-studioreleasesdownload#{version}fuse_osx_#{version.dots_to_underscores}.pkg",
      verified: "github.comfuse-openfuse-studio"
  name "Fuse Studio"
  name "Fuse Open"
  name "Fuse Fusetools"
  desc "Visual desktop tool suite for working with the Fuse framework"
  homepage "https:fuse-open.github.io"

  no_autobump! because: :requires_manual_review

  pkg "fuse_osx_#{version.dots_to_underscores}.pkg"

  uninstall pkgutil: "com.fusetools.fuse"

  zap trash: [
    "~LibraryPreferencescom.fusetools.Fuse.Tray.plist",
    "~LibraryPreferencescom.fusetools.FuseStudio.plist",
    "~LibrarySaved Application Statecom.fusetools.FuseStudio.savedState",
  ]
end