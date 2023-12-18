cask "mongodbpreferencepane" do
  version :latest
  sha256 :no_check

  url "https:github.comremysaissymongodb-macosx-prefspanerawmasterdownloadMongoDB.prefPane.zip"
  name "MongoDB-PrefsPane"
  desc "Preference pane to control MongoDB Server"
  homepage "https:github.comremysaissymongodb-macosx-prefspane"

  prefpane "MongoDB.prefPane"

  caveats do
    discontinued
  end
end