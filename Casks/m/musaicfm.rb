cask "musaicfm" do
  version "1.2.5"
  sha256 "8577257147527190a1ee40ebad4cab685234730ffc9df02fdbdecb54cde3d050"

  url "https:github.comdocterdMusaicFMreleasesdownload#{version}MusaicFM.saver.zip"
  name "MusaicFM Screensaver"
  desc "Screensaver displaying artwork based on Spotify or Last.fm profile data"
  homepage "https:github.comdocterdMusaicFM"

  screen_saver "MusaicFM.saver"

  zap trash: "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferencesByHostcom.obrhoff.musaicfm.*.plist"
end