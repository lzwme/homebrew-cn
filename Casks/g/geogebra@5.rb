cask "geogebra@5" do
  version "5.2.902.0"
  sha256 "85d9c0f9615ba8725306a37aadf39bc8ab8a8f2b55d4ce7b3527c71da7250f00"

  url "https://download.geogebra.org/installers/#{version.major_minor}/GeoGebra-MacOS-Installer-withJava-#{version.dots_to_hyphens}.zip"
  name "GeoGebra"
  desc "Solve, save and share math problems, graph functions, etc"
  homepage "https://www.geogebra.org/"

  livecheck do
    url "https://download.geogebra.org/package/mac"
    regex(%r{/GeoGebra[._-]MacOS[._-]Installer[._-]withJava[._-]v?(\d+(?:-\d+)+)\.zip}i)
    strategy :header_match do |headers, regex|
      match = headers["location"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Geogebra.app"

  uninstall quit:       "org.geogebra#{version.major}.mac",
            login_item: "Geogebra"

  zap trash: "~/Library/Saved Application State/org.geogebra5.mac.savedState"
end