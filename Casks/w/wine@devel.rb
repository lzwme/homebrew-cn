cask "wine@devel" do
  version "10.8"
  sha256 "9abcfa8e06d0c1c7b8c4b54d11fc0a6c184c103964305ed0b967b4454f7d5274"

  # Current winehq packages are deprecated and these are packages from
  # the new maintainers that will eventually be pushed to Winehq.
  # See https:www.winehq.orgpipermailwine-devel2021-July191504.html
  url "https:github.comGcenxmacOS_Wine_buildsreleasesdownload#{version}wine-devel-#{version}-osx64.tar.xz",
      verified: "github.comGcenxmacOS_Wine_builds"
  name "WineHQ-devel"
  desc "Compatibility layer to run Windows applications"
  homepage "https:wiki.winehq.orgMacOS"

  # Not every GitHub release provides a `wine-devel` file, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^v?((?:\d+(?:\.\d+)+)(?:-RC\d)?)$i)
    strategy :github_releases do |json, regex|
      file_regex = ^wine[._-]devel[._-].*?$i

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

  caveats do
    requires_rosetta
  end
end