cask "webstorm" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.117"
  sha256 arm:   "7acfa46536b598b576775892ac46bb570dd06bc9461cc58c51b9efd4afd09139",
         intel: "44363b71b4ad461c07c2c0ae8424f6efabe356b347a2974765f88549a8ee183c"

  url "https:download.jetbrains.comwebstormWebStorm-#{version.csv.first}#{arch}.dmg"
  name "WebStorm"
  desc "JavaScript IDE"
  homepage "https:www.jetbrains.comwebstorm"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=WS&latest=true&type=release"
    strategy :json do |json|
      json["WS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "WebStorm.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}webstorm.wrapper.sh"
  binary shimscript, target: "webstorm"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}WebStorm.appContentsMacOSwebstorm' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsWebStorm#{version.major_minor}",
    "~LibraryCachescom.apple.nsurlsessiondDownloadscom.jetbrains.WebStorm",
    "~LibraryCachesJetBrainsWebStorm#{version.major_minor}",
    "~LibraryLogsJetBrainsWebStorm#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.WebStorm.plist",
    "~LibraryPreferencesjetbrains.webstorm.*.plist",
    "~LibraryPreferencesWebStorm#{version.major_minor}",
    "~LibraryPreferenceswebstorm.plist",
    "~LibrarySaved Application Statecom.jetbrains.WebStorm.savedState",
  ]
end