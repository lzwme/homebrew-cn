cask "wine@staging" do
  version "10.6"
  sha256 "4721403f7c9c225175c7e40034f63858d13ec77ed072d7500d819b902bd6e41b"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https:www.winehq.orgpipermailwine-devel2021-July191504.html
  url "https:github.comGcenxmacOS_Wine_buildsreleasesdownload#{version.major_minor}wine-staging-#{version}-osx64.tar.xz",
      verified: "github.comGcenxmacOS_Wine_builds"
  name "WineHQ-staging"
  desc "Compatibility layer to run Windows applications"
  homepage "https:wiki.winehq.orgMacOS"

  # Not every GitHub release provides a `wine-staging` file, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?((?:\d+(?:\.\d+)+)(?:-RC\d)?)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^wine[._-]staging[._-].*?$i

      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["assets"]&.any? { |asset| asset["name"]&.match?(file_regex) }

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: [
    "wine-stable",
    "wine@devel",
  ]
  depends_on cask: "gstreamer-runtime"
  depends_on macos: ">= :catalina"

  app "Wine Staging.app"
  dir_path = "#{appdir}Wine Staging.appContentsResources"
  binary "#{dir_path}startbinappdb"
  binary "#{dir_path}startbinwinehelp"
  binary "#{dir_path}winebinmsidb"
  binary "#{dir_path}winebinmsiexec"
  binary "#{dir_path}winebinnotepad"
  binary "#{dir_path}winebinregedit"
  binary "#{dir_path}winebinregsvr32"
  binary "#{dir_path}winebinwine"
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
        "~LibrarySaved Application Stateorg.winehq.wine-staging.wine.savedState",
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