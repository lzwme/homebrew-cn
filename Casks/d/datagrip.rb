cask "datagrip" do
  arch arm: "-aarch64"

  version "2025.1.3,251.26094.87"
  sha256 arm:   "83da07ddd46fe95aed36d98cbb61c7f81097dc38abe5515933653746859b396c",
         intel: "006fb7a0875c8fd205cd1d4204dee3be87d1fe359375b75e20ee6e0d21ca7d00"

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