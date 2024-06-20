cask "pibar" do
  version "1.1.2"
  sha256 "61808096da94b8e7f857e48b0bd499f28ad9f3822ba0d0fed29be9d6b1163949"

  url "https:amiantos.s3.amazonaws.comPiBar-#{version}.zip",
      verified: "amiantos.s3.amazonaws.com"
  name "PiBar"
  desc "Pi-hole(s) management in the menu bar"
  homepage "https:github.comamiantospibar"

  app "PiBar.app"

  zap trash: [
    "~LibraryApplication Scriptsnet.amiantos.PiBar",
    "~LibraryContainersnet.amiantos.PiBar",
  ]
end