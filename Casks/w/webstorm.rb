cask "webstorm" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.40"
  sha256 arm:   "2d65e2f9737fa436ad099b1d7a0034fe1143521df45ea785e7162d504175b4e9",
         intel: "1e403680ee7eb9e4aa5c35d3138b0a95477b180e839b501e8b4b8a88878335cb"

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