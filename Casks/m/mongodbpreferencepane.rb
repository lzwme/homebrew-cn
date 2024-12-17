cask "mongodbpreferencepane" do
  version :latest
  sha256 :no_check

  url "https:github.comremysaissymongodb-macosx-prefspanerawmasterdownloadMongoDB.prefPane.zip"
  name "MongoDB-PrefsPane"
  desc "Preference pane to control MongoDB Server"
  homepage "https:github.comremysaissymongodb-macosx-prefspane"

  disable! date: "2024-12-16", because: :discontinued

  prefpane "MongoDB.prefPane"

  caveats do
    requires_rosetta
  end
end