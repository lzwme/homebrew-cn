cask "shotcut" do
  version "25.03.29"
  sha256 "7a043ecb4c109084c930b96bba6847d9b8ca7cadc6572f12cd2539e76c7099d6"

  url "https:github.commltframeworkshotcutreleasesdownloadv#{version.csv.first}shotcut-macos-#{version.csv.second || version.csv.first.no_dots}.dmg",
      verified: "github.commltframeworkshotcut"
  name "Shotcut"
  desc "Video editor"
  homepage "https:www.shotcut.org"

  # The tag version can differ from the filename version, so we include both in
  # the `version` when necessary.
  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)shotcut[._-]macos[._-]v?(\d+(?:\.\d+)*)\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        next match[1] if match[1].tr(".", "") == match[2].tr(".", "")

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :big_sur"

  app "Shotcut.app"

  zap trash: [
    "~LibraryApplication SupportMeltytech",
    "~LibraryCachesMeltytech",
    "~LibraryPreferencescom.meltytech.Shotcut.plist",
  ]
end