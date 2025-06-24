cask "clion" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.39"
  sha256 arm:   "b415b03f8099cb4bcfd443562f9a88aecbe641ba387586d437031b5d2dc2726d",
         intel: "8144071d2c4485b5fd2447a00be3577533a7bc5c510b4b4fdd5db68bb93607a1"

  url "https:download.jetbrains.comcppCLion-#{version.csv.first}#{arch}.dmg"
  name "CLion"
  desc "C and C++ IDE"
  homepage "https:www.jetbrains.comclion"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=CL&latest=true&type=release"
    strategy :json do |json|
      json["CL"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "CLion.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}clion.wrapper.sh"
  binary shimscript, target: "clion"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}CLion.appContentsMacOSclion' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsCLion#{version.major_minor}",
    "~LibraryCachesJetBrainsCLion#{version.major_minor}",
    "~LibraryLogsJetBrainsCLion#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.CLion.plist",
    "~LibrarySaved Application Statecom.jetbrains.CLion.savedState",
  ]
end