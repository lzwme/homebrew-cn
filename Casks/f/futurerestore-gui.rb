cask "futurerestore-gui" do
  version "1.98.3"
  sha256 "44d37f7d74393018b71c641dd98e229e78eb95915b4733aa586723856235c04f"

  url "https:github.comCoocooFroggyFutureRestore-GUIreleasesdownloadv#{version}FutureRestore-GUI-Mac-#{version}.dmg"
  name "FutureRestore GUI"
  desc "Graphical interface for FutureRestore"
  homepage "https:github.comCoocooFroggyFutureRestore-GUI"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "FutureRestore GUI.app"

  zap trash: "~FutureRestoreGUI"

  caveats do
    requires_rosetta
  end
end