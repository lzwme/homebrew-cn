cask "goland" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.127"
  sha256 arm:   "a30940d1b2659487ababc3a9ad8e4770236e90ad6c732cb1fd0c24690829a0ce",
         intel: "6d3c732fb3aadc7dad9bb6dafd294be04c82a4dd994223e4982b77213bf9a4b6"

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