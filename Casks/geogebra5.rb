cask "geogebra5" do
  version "5.2.823.0"
  sha256 "ad10f8b2f038a44ce3089e842ae4fcfaadefb926213f7fb1a51a07ede8db8a64"

  url "https://download.geogebra.org/installers/#{version.major_minor}/GeoGebra-MacOS-Installer-withJava-#{version.dots_to_hyphens}.zip"
  name "GeoGebra"
  desc "Solve, save and share math problems, graph functions, etc"
  homepage "https://www.geogebra.org/"

  livecheck do
    url "https://download.geogebra.org/package/mac"
    regex(%r{/GeoGebra[._-]MacOS[._-]Installer[._-]withJava[._-]v?(\d+(?:-\d+)+)\.zip}i)
    strategy :header_match do |headers, regex|
      match = headers["location"][regex, 1]
      next if match.blank?

      match.tr("-", ".")
    end
  end

  app "Geogebra.app"

  uninstall quit:       "org.geogebra#{version.major}.mac",
            login_item: "Geogebra"

  zap trash: "~/Library/Saved Application State/org.geogebra5.mac.savedState"
end