cask "intellij-idea-ce" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.121"
  sha256 arm:   "61a64b8abf0b350cb14f963975fc87ec574bc4b50ae7944980c43c816ffad5a8",
         intel: "c64c7ff7fe2e73d7552f1727d912bb5f901d040c7269b4292f94190475580c2b"

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