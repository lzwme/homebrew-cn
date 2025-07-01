cask "rider" do
  arch arm: "-aarch64"

  version "2025.1.4,251.26927.67"
  sha256 arm:   "b42644a5fcf1c107d8582eb0f74a8a54e03fb88f029b5d5eb53902721c305ec0",
         intel: "e0eb853c15bcf4eab5f06a009090fa83697cc513fbd0d68d6639d88ecd850630"

  url "https:download.jetbrains.comriderJetBrains.Rider-#{version.csv.first}#{arch}.dmg"
  name "JetBrains Rider"
  desc ".NET IDE"
  homepage "https:www.jetbrains.comrider"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=RD&latest=true&type=release"
    strategy :json do |json|
      json["RD"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Rider.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}rider.wrapper.sh"
  binary shimscript, target: "rider"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}Rider.appContentsMacOSrider' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportRider#{version.major_minor}",
    "~LibraryCachesRider#{version.major_minor}",
    "~LibraryLogsRider#{version.major_minor}",
    "~LibraryPreferencesjetbrains.rider.71e559ef.plist",
    "~LibraryPreferencesRider#{version.major_minor}",
    "~LibrarySaved Application Statecom.jetbrains.rider.savedState",
  ]
end