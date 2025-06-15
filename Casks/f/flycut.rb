cask "flycut" do
  version "1.9.6"
  sha256 "bc1a73b9cb4b4d316fa11572f43383f0f02fc7e6ba88bbed046cc1b074336862"

  url "https:github.comTermiTFlycutreleasesdownload#{version}Flycut.#{version}.zip"
  name "Flycut"
  desc "Clipboard manager for developers"
  homepage "https:github.comTermiTFlycut"

  no_autobump! because: :requires_manual_review

  app "Flycut.app"

  zap trash: "~LibraryPreferencescom.generalarcade.flycut.plist"
end