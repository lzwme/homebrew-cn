cask "koa11y" do
  version "3.0.0"
  sha256 "38eee107e25b9595955c0ef53f0dcfa44630f94003da781e2607a396469bc4da"

  url "https:github.comopen-indyKoa11yreleasesdownloadv#{version}OSX_Koa11y_#{version}.zip",
      verified: "github.comopen-indyKoa11y"
  name "Koa11y"
  desc "Easily check for website accessibility issues"
  homepage "https:open-indy.github.ioKoa11y"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-21", because: :unmaintained

  app "Koa11y.app"

  caveats do
    requires_rosetta
  end
end