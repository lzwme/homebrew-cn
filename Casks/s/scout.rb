cask "scout" do
  version "2.18.16"
  sha256 "b9d38e1f80c12f93f806360ee0dea096a5e262b1436a9e2664ca52a2f7955658"

  url "https:github.comscout-appscout-appreleasesdownloadv#{version}OSX_Scout-App_#{version}.zip",
      verified: "github.comscout-appscout-app"
  name "Scout-App"
  desc "Simple Sass processor"
  homepage "https:scout-app.io"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-11", because: :unmaintained

  app "Scout-App.app"

  zap trash: "~LibraryApplication Supportscout-app"

  caveats do
    requires_rosetta
  end
end