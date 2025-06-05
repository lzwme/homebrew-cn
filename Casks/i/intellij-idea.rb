cask "intellij-idea" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.121"
  sha256 arm:   "1c1afc32c8edcf1d2057a505f7f0b0dd1f1a20a6859172c1dd6a91a311a3167b",
         intel: "bacfa3bcf48d57d8e8ca8d352895025ffc42ce395b9b0074b3b566dc217324c9"

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