cask "rustrover" do
  arch arm: "-aarch64"

  version "2025.1.5,251.26927.79"
  sha256 arm:   "9386f41063a209d4634098bc14e8e63d3cf030b3f8b83524b61d99bf992905d1",
         intel: "320183fdab31207bf56396e97ba4c15549feec71885f5f390a70a1c1cd81ecc7"

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