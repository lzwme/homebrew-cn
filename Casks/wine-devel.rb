cask "wine-devel" do
  version "9.2"
  sha256 "ec58e5db3e6c76dae43a4975ae0d80bd22093297d94b3bd94e2fb59185bc1e92"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https:www.winehq.orgpipermailwine-devel2021-July191504.html
  url "https:github.comGcenxmacOS_Wine_buildsreleasesdownload#{version}wine-devel-#{version}-osx64.tar.xz",
      verified: "github.comGcenxmacOS_Wine_builds"
  name "WineHQ-devel"
  desc "Compatibility layer to run Windows applications"
  homepage "https:wiki.winehq.orgMacOS"

  livecheck do
    url :url
    strategy :github_latest
    regex(^v?((?:\d+(?:\.\d+)+)(?:-RC\d)?)$i)
  end

  conflicts_with cask: [
    "wine-stable",
    "wine-staging",
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :catalina"

  app "Wine Devel.app"
  binary "#{appdir}Wine Devel.appContentsResourcesstartbinappdb"
  binary "#{appdir}Wine Devel.appContentsResourcesstartbinwinehelp"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinmsidb"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinmsiexec"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinnotepad"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinregedit"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinregsvr32"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwine"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwine-preloader"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwine64"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwine64-preloader"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwineboot"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwinecfg"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwineconsole"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwinedbg"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwinefile"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwinemine"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwinepath"
  binary "#{appdir}Wine Devel.appContentsResourceswinebinwineserver"

  zap trash: [
        "~.localshareapplicationswine*",
        "~.localshareiconshicolor**application-x-wine*",
        "~.localsharemimeapplicationx-wine*",
        "~.localsharemimepackagesx-wine*",
        "~.wine",
        "~.wine32",
        "~LibrarySaved Application Stateorg.winehq.wine-devel.wine.savedState",
      ],
      rmdir: [
        "~.localshareapplications",
        "~.localshareicons",
        "~.localsharemime",
      ]

  caveats <<~EOS
    #{token} supports both 32-bit and 64-bit. It is compatible with an existing
    32-bit wine prefix, but it will now default to 64-bit when you create a new
    wine prefix. The architecture can be selected using the WINEARCH environment
    variable which can be set to either win32 or win64.

    To create a new pure 32-bit prefix, you can run:
      $ WINEARCH=win32 WINEPREFIX=~.wine32 winecfg

    See the Wine FAQ for details: https:wiki.winehq.orgFAQ#Wineprefixes
  EOS
end