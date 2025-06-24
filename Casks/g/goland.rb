cask "goland" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.50"
  sha256 arm:   "f58070d3e49b61dccd8ce218f41558ad9904620860f58aa60fb4b683efed7aa9",
         intel: "daeab59912d6530605ac89b18d4cc462f273793153b557e4a06392bcc31de015"

  url "https:download.jetbrains.comgogoland-#{version.csv.first}#{arch}.dmg"
  name "Goland"
  desc "Go (golang) IDE"
  homepage "https:www.jetbrains.comgo"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=GO&latest=true&type=release"
    strategy :json do |json|
      json["GO"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "GoLand.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}goland.wrapper.sh"
  binary shimscript, target: "goland"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}GoLand.appContentsMacOSgoland' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsGoLand",
    "~LibraryApplication SupportJetBrainsGoLand#{version.major_minor}",
    "~LibraryCachesJetBrainsGoLand#{version.major_minor}",
    "~LibraryLogsJetBrainsGoLand#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.goland.plist",
    "~LibraryPreferencesGoLand#{version.major_minor}",
    "~LibrarySaved Application Statecom.jetbrains.goland.SavedState",
  ]
end