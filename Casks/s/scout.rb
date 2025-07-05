cask "scout" do
  version "2.18.16"
  sha256 "b9d38e1f80c12f93f806360ee0dea096a5e262b1436a9e2664ca52a2f7955658"

  url "https://ghfast.top/https://github.com/scout-app/scout-app/releases/download/v#{version}/OSX_Scout-App_#{version}.zip",
      verified: "github.com/scout-app/scout-app/"
  name "Scout-App"
  desc "Simple Sass processor"
  homepage "https://scout-app.io/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-11", because: :unmaintained

  app "Scout-App.app"

  zap trash: "~/Library/Application Support/scout-app"

  caveats do
    requires_rosetta
  end
end