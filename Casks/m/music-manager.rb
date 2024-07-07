cask "music-manager" do
  version "1.0.635.372"
  sha256 :no_check

  url "https:dl.google.comdlandroidjumpermac6350372musicmanager.dmg"
  name "Google Play Music Manager"
  desc "Upload music to the Google Music library"
  homepage "https:play.google.commusiclisten"

  disable! date: "2024-07-06", because: :no_longer_available

  # Renamed for consistency: app name is different in the Finder and in a shell.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull4282
  app "MusicManager.app", target: "Music Manager.app"

  uninstall quit:   "com.google.musicmanager",
            delete: "~LibraryPreferencePanesMusicManager.prefPane"

  zap trash: [
    "~LibraryApplication SupportGoogleMusicManager",
    "~LibraryLogsMusicManager",
    "~LibraryPreferencescom.google.musicmanager.plist",
  ]
end