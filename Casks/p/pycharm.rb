cask "pycharm" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.74"
  sha256 arm:   "2998906836db6b28f1bd25f9e357cd35a60782d246a7a8b7fc4e4be1d4cf6730",
         intel: "60514c4e7664286a28c0e72f9fd7b402a519d7336dc77cc88a5d28c12c3bb1e8"

  url "https:download.jetbrains.compythonpycharm-professional-#{version.csv.first}#{arch}.dmg"
  name "PyCharm"
  name "PyCharm Professional"
  desc "IDE for professional Python development"
  homepage "https:www.jetbrains.compycharm"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=PCP&latest=true&type=release"
    strategy :json do |json|
      json["PCP"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PyCharm.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}pycharm.wrapper.sh"
  binary shimscript, target: "pycharm"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}PyCharm.appContentsMacOSpycharm' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsPyCharm#{version.major_minor}",
    "~LibraryApplication SupportPyCharm#{version.major_minor}",
    "~LibraryCachesJetBrainsPyCharm#{version.major_minor}",
    "~LibraryLogsJetBrainsPyCharm#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.pycharm.plist",
    "~LibraryPreferencesjetbrains.pycharm.*.plist",
    "~LibraryPreferencesPyCharm#{version.major_minor}",
    "~LibrarySaved Application Statecom.jetbrains.pycharm.savedState",
  ]
end