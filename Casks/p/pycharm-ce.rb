cask "pycharm-ce" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.74"
  sha256 arm:   "3c377007ec92d2e60dee67a2a9fb5e34d2d4dfa471886b107a2d8ccb278b2dd9",
         intel: "79f82beaf6004728d99dd2bcbda490131fbcd4fb85f1b85a1fa431700d721b03"

  url "https:download.jetbrains.compythonpycharm-community-#{version.csv.first}#{arch}.dmg"
  name "Jetbrains PyCharm Community Edition"
  name "PyCharm CE"
  desc "IDE for Python programming - Community Edition"
  homepage "https:www.jetbrains.compycharm"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=PCC&latest=true&type=release"
    strategy :json do |json|
      json["PCC"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PyCharm CE.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}pycharm.wrapper.sh"
  binary shimscript, target: "pycharm-ce"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}PyCharm CE.appContentsMacOSpycharm' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsPyCharmCE#{version.major_minor}",
    "~LibraryApplication SupportPyCharm#{version.major_minor}",
    "~LibraryCachescom.apple.pythonApplicationsPyCharm CE.app",
    "~LibraryCachesJetBrainsPyCharmCE#{version.major_minor}",
    "~LibraryCachesPyCharm#{version.major_minor}",
    "~LibraryCachesPyCharmCE#{version.major_minor}",
    "~LibraryLogsJetBrainsPyCharmCE#{version.major_minor}",
    "~LibraryLogsPyCharm#{version.major_minor}",
    "~LibraryLogsPyCharmCE#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.pycharm.ce.plist",
    "~LibraryPreferencesjetbrains.jetprofile.asset.plist",
    "~LibraryPreferencesPyCharm#{version.major_minor}",
    "~LibraryPreferencesPyCharmCE#{version.major_minor}",
    "~LibrarySaved Application Statecom.jetbrains.pycharm.ce.savedState",
    "~LibrarySaved Application Statecom.jetbrains.pycharm.savedState",
  ]
end