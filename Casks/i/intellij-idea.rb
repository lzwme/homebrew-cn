cask "intellij-idea" do
  arch arm: "-aarch64"

  version "2025.1,251.23774.435"
  sha256 arm:   "2877c9ec5cfef9afa09c489083aa4c93f400d35556953ee757a4ee599432c601",
         intel: "86c568d302a2a25185fd912d82c6e99e423767ea1442c716f0ee34292736c35d"

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