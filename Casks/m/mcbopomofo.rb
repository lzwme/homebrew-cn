cask "mcbopomofo" do
  version "2.9.0"
  sha256 "00ec5f68de9784819aaf7b91585347b6abb380c408591369f4b4710dca525426"

  url "https:github.comopenvanillaMcBopomoforeleasesdownload#{version}McBopomofo-Installer-#{version}.zip",
      verified: "github.comopenvanillaMcBopomofo"
  name "McBopomofo"
  desc "Input method for Bopomofo (Phonetic Symbols of Mandarin Chinese)"
  homepage "https:mcbopomofo.openvanilla.org"

  installer manual: "McBopomofoInstaller.app"

  uninstall delete: "~LibraryInput MethodsMcBopomofo.app"

  zap trash: "~LibrarySaved Application Stateorg.openvanilla.McBopomofo.McBopomofoInstaller.savedState"
end