cask "pyzo" do
  version "4.15.0"
  sha256 "e9c25aae926096b3c1d6267368ee39951021c074a96ab937a46d85d6ad5b21ed"

  url "https:github.compyzopyzoreleasesdownloadv#{version}pyzo-#{version}-macos_x86_64.dmg",
      verified: "github.compyzopyzo"
  name "Pyzo"
  desc "Python IDE focused on interactivity and introspection"
  homepage "https:pyzo.org"

  app "pyzo.app"

  zap trash: "~LibraryApplication Supportpyzo"
end