cask "guijs" do
  version "0.1.19"
  sha256 "857bed89fe461edeca980a5bb17ec53016dd64ffc0b4e49a76b729f5fa7b594a"

  url "https:github.comAkryumguijsreleasesdownloadv#{version}guijs.app.tgz",
      verified: "github.comAkryumguijs"
  name "guijs"
  desc "Graphical interface to manage JS projects"
  homepage "https:guijs.dev"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "guijs.app"

  zap trash: [
    "~LibraryCachesguijs",
    "~LibraryWebKitguijs",
  ]
end