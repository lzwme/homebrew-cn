cask "phpstorm" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.148"
  sha256 arm:   "8bb7acf16076e4a32b522107bc359197bb2ee0eeebe0ed5feb1d25d9110830c1",
         intel: "2f7c9b0ec1947c7bb2247fd3a949de9921e82e9a2801e388f6cf9d4421073dbd"

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