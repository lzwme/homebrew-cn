cask "pycharm" do
  arch arm: "-aarch64"

  version "2025.1.1.1,251.25410.159"
  sha256 arm:   "42c62357c134fe8b7eba9d365dff53aa3b6519b9e94fd4866e1ad69a999965f3",
         intel: "5bb6ff2f27d3f34c93b1b94b29a32463c78428bc3cc9982c7e6fd50982966c30"

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