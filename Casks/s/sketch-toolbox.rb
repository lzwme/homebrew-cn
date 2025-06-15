cask "sketch-toolbox" do
  version "0.5.1"
  sha256 :no_check

  url "http://sketchtoolbox.com/Sketch%20Toolbox.zip"
  name "Sketch Toolbox"
  desc "Plugin manager for Sketch"
  homepage "http://sketchtoolbox.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-12", because: :discontinued

  app "Sketch Toolbox.app"

  caveats do
    requires_rosetta
  end
end