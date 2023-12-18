cask "ace-link" do
  version "2.0.6"
  sha256 "4616e4063e45c3f4c624df884ff1a367ac8ad9b545142099bfbef3a0396fdd9e"

  url "https:github.comblaise-ioacelinkreleasesdownload#{version}Ace.Link.#{version}.dmg"
  name "Ace Link"
  desc "Menu bar app that allows playing Ace Stream video streams in the VLC player"
  homepage "https:github.comblaise-ioacelink"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"
  depends_on cask: [
    "vlc",
    "docker",
  ]

  app "Ace Link.app"

  uninstall quit: "blaise.io.acelink"

  zap trash: "~LibraryApplication SupportAce Link"
end