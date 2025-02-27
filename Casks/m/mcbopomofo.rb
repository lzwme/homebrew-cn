cask "mcbopomofo" do
  version "2.9.1"
  sha256 "efe01f2d05a12971704b4a292bf35eca4faca20203a10991bc1d715456e8a705"

  url "https:github.comopenvanillaMcBopomoforeleasesdownload#{version}McBopomofo-Installer-#{version}.zip",
      verified: "github.comopenvanillaMcBopomofo"
  name "McBopomofo"
  desc "Input method for Bopomofo (Phonetic Symbols of Mandarin Chinese)"
  homepage "https:mcbopomofo.openvanilla.org"

  installer manual: "McBopomofoInstaller.app"

  uninstall delete: "~LibraryInput MethodsMcBopomofo.app"

  zap trash: "~LibrarySaved Application Stateorg.openvanilla.McBopomofo.McBopomofoInstaller.savedState"
end