cask "hush" do
  version "1.0"
  sha256 "ed5050e0806d633a717807f90e28acf4b6c2ebcd789b68d3b1c4d461aba0dfc7"

  url "https:github.comobladorhushreleasesdownloadv#{version}Hush.dmg",
      verified: "github.comobladorhush"
  name "Hush"
  desc "Block nags to accept cookies and privacy invasive tracking in Safari"
  homepage "https:oblador.github.iohush"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "Hush.app"

  zap trash: [
    "~LibraryApplication Scriptsse.oblador.Hush",
    "~LibraryApplication Scriptsse.oblador.Hush.ContentBlocker",
    "~LibraryContainersse.oblador.Hush",
    "~LibraryContainersse.oblador.Hush.ContentBlocker",
  ]
end