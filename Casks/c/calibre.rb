cask "calibre" do
  on_high_sierra :or_older do
    version "3.48.0"
    sha256 "68829cd902b8e0b2b7d5cf7be132df37bcc274a1e5720b4605d2dd95f3a29168"

    livecheck do
      skip "Legacy version"
    end
  end
  on_mojave do
    version "5.44.0"
    sha256 "89d7772ba1b95d219b34e285353340a174a013e06b4d8ad370433b3b98c94ad4"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina do
    version "6.11.0"
    sha256 "d7c40f3f35ba9043c13303632526f135b2c4086471a5c09ceb8b397c55c076fa"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur do
    version "6.29.0"
    sha256 "2f76428ae19617875c5725cd892751a80eb2acdda76e06cd19c2f21a63966998"

    livecheck do
      skip "Legacy version"
    end
  end
  on_monterey do
    version "6.29.0"
    sha256 "2f76428ae19617875c5725cd892751a80eb2acdda76e06cd19c2f21a63966998"

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "7.20.0"
    sha256 "9046f13b62bd168ec2a65c419f42313c8c21f3cc4a4d8fee7622e30b5678255c"

    livecheck do
      url "https:calibre-ebook.comdistosx"
      strategy :header_match
    end
  end

  # Do not change this URL to the GitHub repo. Releases are removed from GitHub
  # after a new release, which breaks the cask. We have accepted that downloads
  # from the homepage may be slow for some users.
  # See https:github.comHomebrewhomebrew-caskpull183664
  url "https:download.calibre-ebook.com#{version}calibre-#{version}.dmg"
  name "calibre"
  desc "E-books management software"
  homepage "https:calibre-ebook.com"

  app "calibre.app"
  binary "#{appdir}calibre.appContentsMacOScalibre"
  binary "#{appdir}calibre.appContentsMacOScalibre-complete"
  binary "#{appdir}calibre.appContentsMacOScalibre-customize"
  binary "#{appdir}calibre.appContentsMacOScalibre-debug"
  binary "#{appdir}calibre.appContentsMacOScalibre-parallel"
  binary "#{appdir}calibre.appContentsMacOScalibre-server"
  binary "#{appdir}calibre.appContentsMacOScalibre-smtp"
  binary "#{appdir}calibre.appContentsMacOScalibredb"
  binary "#{appdir}calibre.appContentsMacOSebook-convert"
  binary "#{appdir}calibre.appContentsMacOSebook-device"
  binary "#{appdir}calibre.appContentsMacOSebook-edit"
  binary "#{appdir}calibre.appContentsMacOSebook-meta"
  binary "#{appdir}calibre.appContentsMacOSebook-polish"
  binary "#{appdir}calibre.appContentsMacOSebook-viewer"
  binary "#{appdir}calibre.appContentsMacOSfetch-ebook-metadata"
  binary "#{appdir}calibre.appContentsMacOSlrf2lrs"
  binary "#{appdir}calibre.appContentsMacOSlrfviewer"
  binary "#{appdir}calibre.appContentsMacOSlrs2lrf"
  binary "#{appdir}calibre.appContentsMacOSmarkdown-calibre"
  binary "#{appdir}calibre.appContentsMacOSweb2disk"

  zap trash: [
    "~LibraryApplication Supportcalibre-ebook.com",
    "~LibraryCachescalibre",
    "~LibraryPreferencescalibre",
    "~LibraryPreferencescom.calibre-ebook.ebook-viewer.plist",
    "~LibraryPreferencesnet.kovidgoyal.calibre.plist",
    "~LibrarySaved Application Statecom.calibre-ebook.ebook-viewer.savedState",
    "~LibrarySaved Application Statenet.kovidgoyal.calibre.savedState",
  ]
end