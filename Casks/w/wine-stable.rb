cask "wine-stable" do
  version "8.0.1"
  sha256 "74cc64e1a1e85e0dde73667a88c74ec2993478dcf855ee03f1f4ca51458c1a4c"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https:www.winehq.orgpipermailwine-devel2021-July191504.html
  url "https:github.comGcenxmacOS_Wine_buildsreleasesdownload#{version}wine-stable-#{version}-osx64.tar.xz",
      verified: "github.comGcenxmacOS_Wine_builds"
  name "WineHQ-stable"
  desc "Compatibility layer to run Windows applications"
  homepage "https:wiki.winehq.orgMacOS"

  # Not every GitHub release provides a `wine-stable` file, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?(\d+(?:[.-]\d+)+)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^wine-stable[._-].*?$i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"].match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: [
    "wine-devel",
    "wine-staging",
  ]

  app "Wine Stable.app"
  binary "#{appdir}Wine Stable.appContentsResourcesstartbinappdb"
  binary "#{appdir}Wine Stable.appContentsResourcesstartbinwinehelp"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinmsiexec"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinnotepad"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinregedit"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinregsvr32"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwine"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwine64"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwineboot"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwinecfg"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwineconsole"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwinedbg"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwinefile"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwinemine"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwinepath"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwineserver"

  zap trash: [
        "~.localshareapplicationswine*",
        "~.localshareiconshicolor**application-x-wine*",
        "~.localsharemimeapplicationx-wine*",
        "~.localsharemimepackagesx-wine*",
        "~.wine",
        "~.wine32",
        "~LibrarySaved Application Stateorg.winehq.wine-stable.wine.savedState",
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