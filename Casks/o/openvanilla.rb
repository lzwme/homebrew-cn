cask "openvanilla" do
  version "1.6.4,3310"
  sha256 "06e5cf778bd19ea05d85d037d472dffd8ffad6cc1dfb51814435db14f1eb139e"

  url "https:github.comopenvanillaopenvanillareleasesdownload#{version.csv.first}OpenVanilla-Installer-Mac-#{version.csv.first}.zip",
      verified: "github.comopenvanillaopenvanilla"
  name "OpenVanilla"
  desc "Provides common input methods"
  homepage "https:openvanilla.org"

  livecheck do
    url "https:raw.githubusercontent.comopenvanillaopenvanillamasterSourceMacOpenVanilla-Info.plist"
    strategy :xml do |xml|
      short_version = xml.elements["key[text()='CFBundleShortVersionString']"]&.next_element&.text&.strip
      version = xml.elements["key[text()='CFBundleVersion']"]&.next_element&.text&.strip
      next if short_version.blank? || version.blank?

      "#{short_version},#{version}"
    end
  end

  container nested: "OpenVanillaInstaller.appContentsResourcesNotarizedArchivesOpenVanilla-r#{version.csv.second}.zip"

  input_method "OpenVanilla.app"

  caveats do
    logout
  end
end