cask "clion" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.104"
  sha256 arm:   "475280e277cc94d18de228bf5f81ebd6ff14084c2e1d2b0db5b4612007dc46fe",
         intel: "e7558d0196390c18e2c11143aa59f2ad56c020d43ebd05057f997fa117abb484"

  url "https:download.jetbrains.comcppCLion-#{version.csv.first}#{arch}.dmg"
  name "CLion"
  desc "C and C++ IDE"
  homepage "https:www.jetbrains.comclion"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=CL&latest=true&type=release"
    strategy :json do |json|
      json["CL"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "CLion.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}clion.wrapper.sh"
  binary shimscript, target: "clion"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}CLion.appContentsMacOSclion' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsCLion#{version.major_minor}",
    "~LibraryCachesJetBrainsCLion#{version.major_minor}",
    "~LibraryLogsJetBrainsCLion#{version.major_minor}",
    "~LibraryPreferencescom.jetbrains.CLion.plist",
    "~LibrarySaved Application Statecom.jetbrains.CLion.savedState",
  ]
end