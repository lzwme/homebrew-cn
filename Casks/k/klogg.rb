cask "klogg" do
  version "22.06.0.1289"
  sha256 "e5df7722d0d851852dd9cc3449dd42d1fef3e74edda8c20dc04b38cb852b0fec"

  url "https:github.comvariarkloggreleasesdownloadv#{version.major_minor}klogg-#{version}-OSX-Qt5.dmg"
  name "Klogg"
  desc "Fast, advanced log explorer"
  homepage "https:github.comvariarklogg"

  livecheck do
    url :url
    regex(^klogg[._-]v?(\d+(?:\.\d+)+)-OSX-Qt5\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "klogg.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}klogg.wrapper.sh"
  binary shimscript, target: "klogg"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}klogg.appContentsMacOSklogg' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication Supportklogg",
    "~LibraryPreferencescom.klogg.klogg.plist",
    "~LibraryPreferencescom.klogg.klogg_session.plist",
    "~LibrarySaved Application Statecom.github.variar.klogg.savedState",
  ]

  caveats do
    requires_rosetta
  end
end