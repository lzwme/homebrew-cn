cask "webstorm" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.131"
  sha256 arm:   "298d53fcd1a979e6910f97d9a29ac9bc0ed12386838a93a6d279bb415cf4708f",
         intel: "c33853a8d8a2dd47ce3a795202e2d802a9f1888b2c998c91cdfc9bc66f9bb19a"

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