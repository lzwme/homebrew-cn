cask "musaicfm" do
  version "1.2.6"
  sha256 "d22162103677565da7c009ff0539a9f51d91c13dcb26ee76ff5710758f93dbe7"

  url "https:github.comdocterdMusaicFMreleasesdownload#{version}MusaicFM.saver.zip"
  name "MusaicFM Screensaver"
  desc "Screensaver displaying artwork based on Spotify or Last.fm profile data"
  homepage "https:github.comdocterdMusaicFM"

  screen_saver "MusaicFM.saver"

  zap trash: "~LibraryContainerscom.apple.ScreenSaver.Engine.legacyScreenSaverDataLibraryPreferencesByHostcom.obrhoff.musaicfm.*.plist"
end