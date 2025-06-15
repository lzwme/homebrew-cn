cask "simple-comic" do
  version "1.9.9"
  sha256 "34fa1777c0643d145b8e8ba90b6c6eeb096b21c3beb34728c9df97dad9a1f1ac"

  url "https:github.comMaddTheSaneSimple-ComicreleasesdownloadApp-Store-#{version}Simple.Comic.#{version}.zip"
  name "Simple Comic"
  desc "Comic viewerreader"
  homepage "https:github.comMaddTheSaneSimple-Comic"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Simple Comic.app"

  zap trash: "~LibraryApplication SupportSimple Comic"
end