cask "musescore" do
  version "4.4.3.242971445"
  sha256 "286f6b314bc4dcdcc5f643f3025930ec1230a11348ce37521684e55663d014ef"

  url "https:github.commusescoreMuseScorereleasesdownloadv#{version.major_minor_patch}MuseScore-Studio-#{version}.dmg",
      verified: "github.commusescoreMuseScore"
  name "MuseScore"
  desc "Open-source music notation software"
  homepage "https:musescore.org"

  livecheck do
    url :url
    regex(^MuseScore[._-]Studio[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
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