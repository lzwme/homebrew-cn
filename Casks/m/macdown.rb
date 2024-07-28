cask "macdown" do
  version "0.7.2"
  sha256 "271f11eb64c19fccee2615e092067cdecc29adf0c2ed0703dae9acda8fa0a672"

  url "https:github.comMacDownAppmacdownreleasesdownloadv#{version}MacDown.app.zip",
      verified: "github.comMacDownAppmacdown"
  name "MacDown"
  desc "Open-source Markdown editor"
  homepage "https:macdown.uranusjr.com"

  livecheck do
    url "https:macdown.uranusjr.comsparklemacdownstableappcast.xml"
    strategy :sparkle do |item|
      # 0.7.3 has a known issue, so wait for the next version.
      # See https:github.comMacDownAppmacdownissues1173.
      next version if item.short_version == "0.7.3"

      item.short_version
    end
  end

  auto_updates true

  app "MacDown.app"
  binary "#{appdir}MacDown.appContentsSharedSupportbinmacdown"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.uranusjr.macdown.sfl*",
    "~LibraryApplication SupportMacDown",
    "~LibraryCachescom.uranusjr.macdown",
    "~LibraryCookiescom.uranusjr.macdown.binarycookies",
    "~LibraryPreferencescom.uranusjr.macdown.plist",
    "~LibrarySaved Application Statecom.uranusjr.macdown.savedState",
    "~LibraryWebKitcom.uranusjr.macdown",
  ]

  caveats do
    requires_rosetta
  end
end