cask "intellij-idea-ce" do
  arch arm: "-aarch64"

  version "2025.1.1.1,251.25410.129"
  sha256 arm:   "92ea35ebfcd9e34cd9bda0103ca036fe1f9eb900c005ae33a9295050ad636dae",
         intel: "ee1577a44930b94112819b200acd617cbb3efdfa039df7911094051e9a10e465"

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