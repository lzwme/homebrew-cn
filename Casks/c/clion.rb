cask "clion" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26094.123"
  sha256 arm:   "9a47d3d86f2465f4b741408ad3a792d63a4dff486a05103825e479dae4d63932",
         intel: "f7dde8532ba52d4cfaab37828ba52fa2e159d82baf1fa555c1a0e65bb1186a86"

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