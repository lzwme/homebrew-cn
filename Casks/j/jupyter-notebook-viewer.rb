cask "jupyter-notebook-viewer" do
  version "0.1.6"
  sha256 "af77fa5f0d80e99c2efd977b0dba9b11fb16d33ee10f53f9e34989fb16f12514"

  url "https:github.comtuxunbviewer-appreleasesdownload#{version}nbviewer-app.zip"
  name "Jupyter Notebook Viewer"
  desc "Utility to render Jupyter notebooks"
  homepage "https:github.comtuxunbviewer-app"

  depends_on macos: ">= :sierra"

  app "Jupyter Notebook Viewer.app"

  zap trash: "~LibrarySaved Application Statecom.tinowagner.nbviewer-app.savedState"
end