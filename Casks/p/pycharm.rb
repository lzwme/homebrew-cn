cask "pycharm" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.141"
  sha256 arm:   "89a463c896e4e7f6cf6a624b78305d881756b2a350780bfcecd15d6cb766e54b",
         intel: "41c6187f4f044522d02749f979cef8f127337b2945772070a0ba44c53a6ebf0c"

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