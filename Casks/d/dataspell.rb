cask "dataspell" do
  arch arm: "-aarch64"

  version "2025.1.1,251.25410.158"
  sha256 arm:   "65bbf4da47e5ceecfab5e19f80bec7ddd5f66bfcdc8dc75691cad98958e72af1",
         intel: "a0b3bd8513f98e448a90132dfb61b221cab22938d8a3992627f9cb141cf71926"

  url "https:download.jetbrains.compythondataspell-#{version.csv.first}#{arch}.dmg"
  name "DataSpell"
  desc "IDE for Professional Data Scientists"
  homepage "https:www.jetbrains.comdataspell"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=DS&latest=true&type=release"
    strategy :json do |json|
      json["DS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DataSpell.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}dataspell.wrapper.sh"
  binary shimscript, target: "dataspell"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}DataSpell.appContentsMacOSdataspell' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportDataSpell*",
    "~LibraryApplication SupportJetBrainsDataSpell*",
    "~LibraryCachesJetBrainsDataSpell*",
    "~LibraryLogsJetBrainsDataSpell*",
    "~LibraryPreferencescom.jetbrains.dataspell.plist",
    "~LibraryPreferencesDataSpell*",
    "~LibraryPreferencesjetbrains.dataspell.*.plist",
    "~LibrarySaved Application Statecom.jetbrains.dataspell.savedState",
  ]
end