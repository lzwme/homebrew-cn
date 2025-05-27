cask "rustrover" do
  arch arm: "-aarch64"

  version "2025.1.2,251.25410.115"
  sha256 arm:   "3f12ad41285d6b67dcc577526976b5c394b44caa3f243147143968a505144a79",
         intel: "1419d2aac23965838e16c2bedc31851045f8b9d99ccf93594838a4e329059d92"

  url "https:download.jetbrains.comrustroverRustRover-#{version.csv.first}#{arch}.dmg"
  name "RustRover"
  desc "Rust IDE"
  homepage "https:www.jetbrains.comrust"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=RR&latest=true&type=release"
    strategy :json do |json|
      json["RR"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "RustRover.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}rustrover.wrapper.sh"
  binary shimscript, target: "rustrover"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}RustRover.appContentsMacOSrustrover' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsRustRover#{version.major_minor}",
    "~LibraryCachesJetBrainsRustRover#{version.major_minor}",
    "~LibraryLogsJetBrainsRustRover#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.rustrover.plist",
    "~LibrarySaved Application Statecom.jetbrains.rustrover.savedState",
  ]
end