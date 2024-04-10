cask "xquartz" do
  version "2.8.5"
  sha256 "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782"

  url "https:github.comXQuartzXQuartzreleasesdownloadXQuartz-#{version}XQuartz-#{version}.pkg",
      verified: "github.comXQuartzXQuartz"
  name "XQuartz"
  desc "Open-source version of the X.Org X Window System"
  homepage "https:www.xquartz.org"

  livecheck do
    url "https:www.xquartz.orgreleasessparkle-r1release.xml"
    strategy :sparkle do |item|
      item.short_version.delete_prefix("XQuartz-")
    end
  end

  auto_updates true

  pkg "XQuartz-#{version}.pkg"

  uninstall launchctl: "org.xquartz.privileged_startx",
            pkgutil:   "org.xquartz.X11"

  zap trash: [
        "~.Xauthority",
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.xquartz.x11.sfl*",
        "~LibraryApplication SupportXQuartz",
        "~LibraryCachesorg.xquartz.X11",
        "~LibraryCookiesorg.xquartz.X11.binarycookies",
        "~LibraryHTTPStoragesorg.xquartz.X11",
        "~LibraryLogsX11org.xquartz.log",
        "~LibraryLogsX11org.xquartz.log.old",
        "~LibraryPreferencesorg.xquartz.X11.plist",
        "~LibrarySaved Application Stateorg.xquartz.X11.savedState",
      ],
      rmdir: [
        "~.fonts",
        "~LibraryLogsX11",
      ]
end