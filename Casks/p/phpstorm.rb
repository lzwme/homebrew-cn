cask "phpstorm" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.133"
  sha256 arm:   "0437ba56e1b12b1781ba132d10f9f66c6375cb0609b4755982c7edd1778a3a3b",
         intel: "18b63995efa4e5ef555f08089c998694b4e3fcda84013155e970524f92c1b90e"

  url "https:download.jetbrains.comwebidePhpStorm-#{version.csv.first}#{arch}.dmg"
  name "JetBrains PhpStorm"
  desc "PHP IDE by JetBrains"
  homepage "https:www.jetbrains.comphpstorm"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=PS&latest=true&type=release"
    strategy :json do |json|
      json["PS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PhpStorm.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}phpstorm.wrapper.sh"
  binary shimscript, target: "phpstorm"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}PhpStorm.appContentsMacOSphpstorm' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsconsentOptions",
    "~LibraryApplication SupportJetBrainsPhpStorm#{version.major_minor}",
    "~LibraryCachesJetBrainsPhpStorm#{version.major_minor}",
    "~LibraryLogsJetBrainsPhpStorm#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.PhpStorm.plist",
    "~LibraryPreferencesjetbrains.jetprofile.asset.plist",
  ]
end