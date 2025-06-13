cask "rider" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26094.147"
  sha256 arm:   "04b5d3cd99bb3f04fb75ba115d7523db283a70a0410c9274a88ec888a62d8ca3",
         intel: "9b645982d017d896c46f9cd794807355c1fce90702ed561c121428edc1ec9e09"

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