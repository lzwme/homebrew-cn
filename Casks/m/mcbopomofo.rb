cask "mcbopomofo" do
  version "2.7.1"
  sha256 "acde3309920ff592c635901eb9bd1e3e3508c9a10cf6f4e660b8ea9463c8ab38"

  url "https:github.comopenvanillaMcBopomoforeleasesdownload#{version}McBopomofo-Installer-#{version}.zip",
      verified: "github.comopenvanillaMcBopomofo"
  name "McBopomofo"
  desc "Input method for Bopomofo (Phonetic Symbols of Mandarin Chinese)"
  homepage "https:mcbopomofo.openvanilla.org"

  installer manual: "McBopomofoInstaller.app"

  uninstall delete: "~LibraryInput MethodsMcBopomofo.app"
end