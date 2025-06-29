cask "wine-stable" do
  version "10.0_2"
  sha256 "465330eaced42d033fc24bfb9bc684c179442f8f7359f24c7dc114c375453e55"

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
    regex(^v?(\d+(?:[._-]\d+)+)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^wine[._-]stable[._-].*?$i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  no_autobump! because: :requires_manual_review

  conflicts_with cask: [
    "wine@devel",
    "wine@staging",
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :catalina"

  app "Wine Stable.app"
  binary "#{appdir}Wine Stable.appContentsResourcesstartbinappdb"
  binary "#{appdir}Wine Stable.appContentsResourcesstartbinwinehelp"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinmsidb"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinmsiexec"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinnotepad"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinregedit"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinregsvr32"
  binary "#{appdir}Wine Stable.appContentsResourceswinebinwine"
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

  caveats do
    requires_rosetta
  end
end