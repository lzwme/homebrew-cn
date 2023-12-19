cask "mongodbpreferencepane" do
  version :latest
  sha256 :no_check

  url "https:github.comremysaissymongodb-macosx-prefspanerawmasterdownloadMongoDB.prefPane.zip"
  name "MongoDB-PrefsPane"
  desc "Preference pane to control MongoDB Server"
  homepage "https:github.comremysaissymongodb-macosx-prefspane"

  deprecate! date: "2023-12-17", because: :discontinued

  prefpane "MongoDB.prefPane"
end