cask "outfox" do
  version "0.5.0-pre042,OF5.0.0-042,OutFox-alpha,MacOS-universal-date-20231224"
  sha256 "5c6f772d17e972c7836174af6831a3257619bff4a5c681dbb1ac05cad6180055"

  url "https:github.comTeamRizuOutFoxreleasesdownload#{version.csv.second}#{version.csv.third}-#{version.csv.first}-#{version.csv.fourth}.dmg",
      verified: "github.comTeamRizuOutFox"
  name "OutFox"
  desc "Extensible rhythm game engine based on StepMania"
  homepage "https:projectoutfox.com"

  livecheck do
    url :url
    regex(%r{([^]+?)([^]+)-v?(\d+(?:\.\d+)+[^]*?)-(MacOSX?[^]*)\.dmg$}i)
    strategy :github_releases do |json, regex|
      # Temporarily restrict the ten newest releases, to work around older
      # versions using a 4.13.0 version scheme instead of the newer 0.4.14.
      # TODO: Replace this with `json.map do |release|` when possible
      json[0...9].map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["browser_download_url"]&.match(regex)
          next if match.blank?

          "#{match[3]},#{match[1]},#{match[2]},#{match[4]}"
        end
      end.flatten
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  suite "OutFox"

  zap trash: [
    "~LibraryApplication SupportProject OutFox",
    "~LibraryCachesProject OutFox",
    "~LibraryLogsProject OutFox",
    "~LibraryPreferencescom.teamrizu.outfox.plist",
    "~LibraryPreferencesProject OutFox",
    "~LibrarySaved Application Statecom.teamrizu.outfox.savedState",
  ]

  caveats do
    <<~EOS
      Songs should be installed into `~LibraryApplication SupportProject OutFoxSongs`
      in order to persist between version upgrades.
    EOS
  end
end