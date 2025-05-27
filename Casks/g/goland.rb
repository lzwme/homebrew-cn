cask "goland" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.140"
  sha256 arm:   "52e62d5a616b6ab6bf36f0d40d1925e9f477fcf84e187a2a1194d56d5ccae6ec",
         intel: "0b00984d45430b37538bf9c55f8f93f1476f819fba1bdea2588ffd36d7e91cb3"

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