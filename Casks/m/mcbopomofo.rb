cask "mcbopomofo" do
  version "2.8.1"
  sha256 "169e9c21de49b00f01a02608a7c6506982b24c2debfd81441cff3edbe929cb88"

  url "https:github.comopenvanillaMcBopomoforeleasesdownload#{version}McBopomofo-Installer-#{version}.zip",
      verified: "github.comopenvanillaMcBopomofo"
  name "McBopomofo"
  desc "Input method for Bopomofo (Phonetic Symbols of Mandarin Chinese)"
  homepage "https:mcbopomofo.openvanilla.org"

  installer manual: "McBopomofoInstaller.app"

  uninstall delete: "~LibraryInput MethodsMcBopomofo.app"

  zap trash: "~LibrarySaved Application Stateorg.openvanilla.McBopomofo.McBopomofoInstaller.savedState"
end