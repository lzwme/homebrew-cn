cask "jandi-statusbar" do
  version "1.15"
  sha256 "b2bf4a52247f171d19412b23e5d8a7f461b3d54c2cf3fc7b13bde5afe5457895"

  url "https:github.comtechinparkJandireleasesdownloadv#{version}jandi.dmg"
  name "jandi"
  desc "GitHub contributions in your status bar"
  homepage "https:github.comtechinparkJandi"

  app "jandi.app"

  zap trash: [
    "~LibraryCachescom.tmsae.jandi",
    "~LibraryPreferencescom.tmsae.jandi.plist",
  ]
end