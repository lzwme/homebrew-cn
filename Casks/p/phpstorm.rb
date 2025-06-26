cask "phpstorm" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26927.60"
  sha256 arm:   "34cb7ddf548f2a2883560e8b7a861d587a299b864e30cb8311cd37ec4ad54517",
         intel: "abd27a6baffba215f6e25d79a6cd538736bca1e6d481563455b4a0621dd7fabc"

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