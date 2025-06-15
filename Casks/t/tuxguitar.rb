cask "tuxguitar" do
  version "1.6.6"
  sha256 "87304ed1608495652645ec29d86bad56946618545575a25d87299bca39c9bead"

  url "https:github.comhelge17tuxguitarreleasesdownload#{version}tuxguitar-#{version}-macosx-swt-cocoa-x86_64.app.tar.gz",
      verified: "github.comhelge17tuxguitar"
  name "TuxGuitar"
  desc "Multitrack guitar tablature editor and player"
  homepage "https:www.tuxguitar.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "tuxguitar-#{version}-macosx-swt-cocoa-x86_64.app"

  zap trash: "~LibraryApplication Supporttuxguitar"
end