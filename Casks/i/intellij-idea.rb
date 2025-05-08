cask "intellij-idea" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.109"
  sha256 arm:   "f62879a25a3c63c4d32ea5e76df04d30663eda19a74a7ce1425f1e2616d26ebf",
         intel: "16aad03ddc317d3bd3c124855ad8fa685a2bc6a6ef98e3a85de2bda745908274"

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