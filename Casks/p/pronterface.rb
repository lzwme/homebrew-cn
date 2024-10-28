cask "pronterface" do
  version "2.2.0"
  sha256 "b3fa041bb478b9d66b4a7654d93236b38ad36ec90370891943569c1073886e2b"

  url "https:github.comklimentPrintrunreleasesdownloadprintrun-#{version}printrun-#{version}_macos_x64.zip"
  name "Printrun"
  desc "Control your 3D printer from your PC"
  homepage "https:github.comklimentPrintrun"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "pronterface.app"

  caveats do
    requires_rosetta
  end
end