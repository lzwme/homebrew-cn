cask "openvanilla" do
  version "1.8.2,3442"
  sha256 "19309af5740d750dd36fe99d2ab7a9019983c9d0fe41fa0d8ec9c34dccc453b5"

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