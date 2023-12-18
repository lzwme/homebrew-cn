cask "simple-comic" do
  version "1.9.7"
  sha256 "77957b74391ca924b2e4631b8407bdf20d44a97401606dee4cba84d0d5552572"

  url "https:github.comMaddTheSaneSimple-ComicreleasesdownloadApp-Store-#{version}Simple.Comic.zip"
  name "Simple Comic"
  desc "Comic viewerreader"
  homepage "https:github.comMaddTheSaneSimple-Comic"

  app "Simple Comic.app"

  zap trash: "~LibraryApplication SupportSimple Comic"
end