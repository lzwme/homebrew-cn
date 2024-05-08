cask "ace-link" do
  version "2.1.0"
  sha256 "778e122a739c53aba5e5a8715b630b287089ef89870064a0345c0ee526d44886"

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