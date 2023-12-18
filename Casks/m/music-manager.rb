cask "music-manager" do
  version "1.0.635.372"
  sha256 :no_check

  url "https:dl.google.comdlandroidjumpermac6350372musicmanager.dmg"
  name "Google Play Music Manager"
  desc "Upload music to the Google Music library"
  homepage "https:play.google.commusiclisten"

  livecheck do
    url :url
    strategy :extract_plist
  end

  # Renamed for consistency: app name is different in the Finder and in a shell.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull4282
  app "MusicManager.app", target: "Music Manager.app"

  uninstall delete: "~LibraryPreferencePanesMusicManager.prefPane",
            quit:   "com.google.musicmanager"

  zap trash: [
    "~LibraryApplication SupportGoogleMusicManager",
    "~LibraryLogsMusicManager",
    "~LibraryPreferencescom.google.musicmanager.plist",
  ]
end