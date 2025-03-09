cask "sonic-visualiser" do
  version "5.2.0,5.2"
  sha256 "eb4ad1b63c6fb1374b0d4d717408cbcc204bf91252f88b3e6d8072163381d17c"

  url "https:github.comsonic-visualisersonic-visualiserreleasesdownloadsv_v#{version.csv.second || version.csv.first}Sonic.Visualiser.#{version.csv.first}.dmg",
      verified: "github.comsonic-visualisersonic-visualiser"
  name "Sonic Visualiser"
  desc "Visualisation, analysis, and annotation of music audio recordings"
  homepage "https:www.sonicvisualiser.org"

  livecheck do
    url :url
    regex(%r{\D*(\d+(?:\.\d+)+)Sonic[._-]?Visualiser[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        (match[2] == match[1]) ? match[1] : "#{match[2]},#{match[1]}"
      end
    end
  end

  depends_on macos: ">= :sierra"

  app "Sonic Visualiser.app"

  zap trash: [
    "~LibraryApplication Supportsonic-visualiser",
    "~LibraryPreferencesorg.sonicvisualiser.Sonic Visualiser.plist",
    "~LibraryPreferencesorg.sonicvisualiser.SonicVisualiser.plist",
    "~LibrarySaved Application Stateorg.sonicvisualiser.SonicVisualiser.savedState",
  ]
end