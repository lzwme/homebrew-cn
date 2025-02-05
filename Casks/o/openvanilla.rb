cask "openvanilla" do
  version "1.8.0,3433"
  sha256 "c61705f6b25024bb7adc922b9e03d396e3b91329d757b7065ed16d6e8265451b"

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

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.openvanilla.*.sfl*",
    "~LibraryApplication SupportOpenVanilla",
    "~LibraryPreferencesorg.openvanilla.*",
  ]

  caveats do
    logout
  end
end