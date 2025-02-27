cask "openvanilla" do
  version "1.8.1,3437"
  sha256 "1c5ea2af7a4a8593b0679579be7010cebbde626a34585d4884f4436562af042d"

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