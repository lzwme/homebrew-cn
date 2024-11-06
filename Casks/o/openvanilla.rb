cask "openvanilla" do
  version "1.7.0,3401"
  sha256 "525d43c0ff5235e3abeaebd53ec36a436fdfdaeb31b4208892ba0168d02c3bb7"

  url "https:github.comopenvanillaopenvanillareleasesdownload#{version.csv.first}OpenVanilla-Installer-Mac-#{version.csv.first}.zip",
      verified: "github.comopenvanillaopenvanilla"
  name "OpenVanilla"
  desc "Provides common input methods"
  homepage "https:openvanilla.org"

  livecheck do
    url "https:raw.githubusercontent.comopenvanillaopenvanillamasterSourceMacOpenVanilla-Info.plist"
    strategy :xml do |xml|
      short_version = xml.elements["key[text()='CFBundleShortVersionString']"]&.next_element&.text
      version = xml.elements["key[text()='CFBundleVersion']"]&.next_element&.text
      next if short_version.blank? || version.blank?

      "#{short_version.strip},#{version.strip}"
    end
  end

  container nested: "OpenVanillaInstaller.appContentsResourcesNotarizedArchivesOpenVanilla-r#{version.csv.second}.zip"

  input_method "OpenVanilla.app"

  caveats do
    logout
  end
end