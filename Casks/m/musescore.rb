cask "musescore" do
  version "4.1.1.232071203"
  sha256 "31340ce562e40ba275d5e6be4593f4828231be61bc7ca1f22b5424dc2fba18fd"

  url "https:github.commusescoreMuseScorereleasesdownloadv#{version.major_minor_patch}MuseScore-#{version}.dmg",
      verified: "github.commusescoreMuseScore"
  name "MuseScore"
  desc "Open-source music notation software"
  homepage "https:musescore.org"

  livecheck do
    url :url
    regex(^MuseScore[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
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