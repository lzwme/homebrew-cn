cask "intellij-idea-ce" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.53"
  sha256 arm:   "d912ba961141b315881c16805dd6684d1f0bae321c5baf84d851bdd80d7e9e87",
         intel: "1e640fc2bf96667240389e02e116e3a97c5c6d96060c4656a46bcda7b8440d0f"

  url "https:download.jetbrains.comideaideaIC-#{version.csv.first}#{arch}.dmg"
  name "IntelliJ IDEA Community Edition"
  name "IntelliJ IDEA CE"
  desc "IDE for Java development - community edition"
  homepage "https:www.jetbrains.comidea"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=IIC&latest=true&type=release"
    strategy :json do |json|
      json["IIC"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA CE.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}idea.wrapper.sh"
  binary shimscript, target: "idea-ce"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}IntelliJ IDEA CE.appContentsMacOSidea' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsIdeaIC#{version.major_minor}",
    "~LibraryCachesJetBrainsIdeaIC#{version.major_minor}",
    "~LibraryLogsJetBrainsIdeaIC#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.intellij.ce.plist",
    "~LibrarySaved Application Statecom.jetbrains.intellij.ce.savedState",
  ]
end