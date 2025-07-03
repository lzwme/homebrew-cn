cask "dataspell" do
  arch arm: "-aarch64"

  version "2025.1.2,251.26927.75"
  sha256 arm:   "972e6281794201bb693450ca0941e13840848851799cfba965e02757764d105d",
         intel: "cea1082a3c61a034c201ce1fb3b1e1de16d82725a318ca860f0604e6253138dc"

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