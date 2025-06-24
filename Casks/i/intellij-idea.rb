cask "intellij-idea" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.53"
  sha256 arm:   "88cb043b43d6da25269abae0fec2b41705b5ef72501f384ef4084091e461a1e8",
         intel: "136a3114a3e33e18ad16226ba3b743f8139e113977b43242a0e127aaaa85786f"

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