cask "datagrip" do
  arch arm: "-aarch64"

  version "2025.1.2,251.25410.123"
  sha256 arm:   "6d12a59053db3dfa33079ac79b1ea263e5b3ec6fde01d1d803f6d27afea033de",
         intel: "a6b7dadb262813d867281d700456c7bca82b61bea99e52fd54edec05cd07180e"

  url "https:download.jetbrains.comdatagripdatagrip-#{version.csv.first}#{arch}.dmg"
  name "DataGrip"
  desc "Databases and SQL IDE"
  homepage "https:www.jetbrains.comdatagrip"

  livecheck do
    url "https:data.services.jetbrains.comproductsreleases?code=DG&latest=true&type=release"
    strategy :json do |json|
      json["DG"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DataGrip.app"
  # shim script (https:github.comHomebrewhomebrew-caskissues18809)
  shimscript = "#{staged_path}datagrip.wrapper.sh"
  binary shimscript, target: "datagrip"

  preflight do
    File.write shimscript, <<~EOS
      #!binsh
      exec '#{appdir}DataGrip.appContentsMacOSdatagrip' "$@"
    EOS
  end

  zap trash: [
    "~LibraryApplication SupportJetBrainsDataGrip*",
    "~LibraryCachesJetBrainsDataGrip*",
    "~LibraryLogsJetBrainsDataGrip*",
    "~LibrarySaved Application Statecom.jetbrains.datagrip.savedState",
  ]
end