cask "pycharm-ce" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.141"
  sha256 arm:   "cdcdea2e167c3621f5b5ea8e0150c62d24495192edd2282616676d3f53b06063",
         intel: "38283e62677079d7d830217087c563ac6daf5e71422c03e56082bde9572e3908"

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