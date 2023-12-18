cask "wine-staging" do
  version "8.21"
  sha256 "767eb8c099998de452a4ff2f8bbe8a48d418d1ff3df9c10dd36c6fc2b431ad84"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https:www.winehq.orgpipermailwine-devel2021-July191504.html
  url "https:github.comGcenxmacOS_Wine_buildsreleasesdownload#{version.major_minor}wine-staging-#{version}-osx64.tar.xz",
      verified: "github.comGcenxmacOS_Wine_builds"
  name "WineHQ-staging"
  desc "Compatibility layer to run Windows applications"
  homepage "https:wiki.winehq.orgMacOS"

  livecheck do
    url :url
    regex(^wine-staging[._-]v?(\d+(?:\.\d+)+).*?\.ti)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: [
    "wine-stable",
    "wine-devel",
  ]
  depends_on cask: "gstreamer-runtime"

  app "Wine Staging.app"
  binary "#{appdir}Wine Staging.appContentsResourcesstartbinappdb"
  binary "#{appdir}Wine Staging.appContentsResourcesstartbinwinehelp"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinmsiexec"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinnotepad"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinregedit"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinregsvr32"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwine"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwine64"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwineboot"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwinecfg"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwineconsole"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwinedbg"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwinefile"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwinemine"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwinepath"
  binary "#{appdir}Wine Staging.appContentsResourceswinebinwineserver"

  zap trash: [
        "~.localshareapplicationswine*",
        "~.localshareiconshicolor**application-x-wine*",
        "~.localsharemimeapplicationx-wine*",
        "~.localsharemimepackagesx-wine*",
        "~.wine",
        "~.wine32",
        "~LibrarySaved Application Stateorg.winehq.wine-staging.wine.savedState",
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