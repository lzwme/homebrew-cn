cask "rustrover" do
  arch arm: "-aarch64"

  version "2025.1.4,251.26094.152"
  sha256 arm:   "9f56484888e6b33a034b4d1354a22929b6c701da3da2032ec2b3864b6c973550",
         intel: "c445a87bb152f4486c1e85236778a18dd3b4a3d5cd3e3abc6a2fdd6632dd04a7"

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