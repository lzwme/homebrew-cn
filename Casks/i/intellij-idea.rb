cask "intellij-idea" do
  arch arm: "-aarch64"

  version "2025.1.1.1,251.25410.129"
  sha256 arm:   "5207878b28df2a13e4248c1936ee4fff7c89495e3d4ffdaa3b8da3f21548117e",
         intel: "eccd0ba3f9b1f2f680b946a3658830562fd4369dd11cc618b86671c8e237c375"

  url "https:download.jetbrains.comideaideaIU-#{version.csv.first}#{arch}.dmg"
  name "IntelliJ IDEA Ultimate"
  desc "Java IDE by JetBrains"
  homepage "https:www.jetbrains.comidea"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=IIU&latest=true&type=release"
    strategy :json do |json|
      json["IIU"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "intellij-idea@eap"
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}idea.wrapper.sh"
  binary shimscript, target: "idea"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}IntelliJ IDEA.appContentsMacOSidea' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsIntelliJIdea#{version.major_minor}",
    "~LibraryCachesJetBrainsIntelliJIdea#{version.major_minor}",
    "~LibraryLogsJetBrainsIntelliJIdea#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.intellij.plist",
    "~LibraryPreferencesIntelliJIdea#{version.major_minor}",
    "~LibraryPreferencesjetbrains.idea.*.plist",
    "~LibrarySaved Application Statecom.jetbrains.intellij.savedState",
  ]
end