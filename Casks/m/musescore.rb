cask "musescore" do
  version "4.5.0.250721848,4.5"
  sha256 "000e342851e9ef2a139155510027335b99ced34e23d2e831d480e79793239580"

  url "https:github.commusescoreMuseScorereleasesdownloadv#{version.csv.second}MuseScore-Studio-#{version.csv.first}.dmg",
      verified: "github.commusescoreMuseScore"
  name "MuseScore"
  desc "Open-source music notation software"
  homepage "https:musescore.org"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)MuseScore[._-]Studio[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "MuseScore #{version.major}.app"
  # shim script (https:github.comcaskroomhomebrew-caskissues18809)
  shimscript = "#{staged_path}mscore.wrapper.sh"
  binary shimscript, target: "mscore"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}MuseScore #{version.major}.appContentsMacOSmscore' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportMuseScore",
    "~LibraryCachesMuseScore",
    "~LibraryCachesorg.musescore.MuseScore",
    "~LibraryPreferencesorg.musescore.MuseScore*.plist",
    "~LibrarySaved Application Stateorg.musescore.MuseScore.savedState",
  ]
end