cask "mcbopomofo" do
  version "2.9.2"
  sha256 "ba67fe4f990cd1a6f7e5e96ef3c1889307b1996440c3157db97862f06a50034b"

  url "https:github.comopenvanillaMcBopomoforeleasesdownload#{version}McBopomofo-Installer-#{version}.zip",
      verified: "github.comopenvanillaMcBopomofo"
  name "McBopomofo"
  desc "Input method for Bopomofo (Phonetic Symbols of Mandarin Chinese)"
  homepage "https:mcbopomofo.openvanilla.org"

  installer manual: "McBopomofoInstaller.app"

  uninstall delete: "~LibraryInput MethodsMcBopomofo.app"

  zap trash: "~LibrarySaved Application Stateorg.openvanilla.McBopomofo.McBopomofoInstaller.savedState"
end