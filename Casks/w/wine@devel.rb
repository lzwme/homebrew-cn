cask "wine@devel" do
  version "9.7"
  sha256 "f4c7fbc424fec28a6ec8791e392c2ae918c15d3e0b11034d65edc438e8014f6c"

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
    "wine@staging",
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :catalina"

  app "Wine Devel.app"
  dir_path = "#{appdir}Wine Devel.appContentsResources"
  binary "#{dir_path}startbinappdb"
  binary "#{dir_path}startbinwinehelp"
  binary "#{dir_path}winebinmsidb"
  binary "#{dir_path}winebinmsiexec"
  binary "#{dir_path}winebinnotepad"
  binary "#{dir_path}winebinregedit"
  binary "#{dir_path}winebinregsvr32"
  binary "#{dir_path}winebinwine"
  binary "#{dir_path}winebinwine-preloader"
  binary "#{dir_path}winebinwine64"
  binary "#{dir_path}winebinwine64-preloader"
  binary "#{dir_path}winebinwineboot"
  binary "#{dir_path}winebinwinecfg"
  binary "#{dir_path}winebinwineconsole"
  binary "#{dir_path}winebinwinedbg"
  binary "#{dir_path}winebinwinefile"
  binary "#{dir_path}winebinwinemine"
  binary "#{dir_path}winebinwinepath"
  binary "#{dir_path}winebinwineserver"

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