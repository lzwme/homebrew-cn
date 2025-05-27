cask "rider" do
  arch arm: "-aarch64"

  version "2025.1.2,251.25410.119"
  sha256 arm:   "ab6645bba503f0a9d67b2838d1dd88a81ad81dd34e6015ccaea30400c35659e4",
         intel: "23f3479d1cff5ee1726726bea866ff755b08930e9da43b7ad250e6cb620c1dcf"

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