cask "pycharm-ce" do
  arch arm: "-aarch64"

  version "2025.1.1.1,251.25410.159"
  sha256 arm:   "42f01916e2c773af0c144c74b1bba0d421b34f640c27cb4c5eb7be01a6d7a3d0",
         intel: "4f9b2b6f853ebe95bbc38e7bdec5fe3ecd9ce799701d48e9464414c4616c0355"

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