cask "oscilloscope" do
  version "1.1.0"
  sha256 "5fe6fd174777d28b729704b94d034b5c1ba450b65b841a72928b15412a7c32fb"

  url "https:github.comkritzikratziOscilloscopereleasesdownload#{version}oscilloscope-#{version}-osx.zip"
  name "Oscilloscope"
  desc "Mimic the aesthetic of ray-oscilloscopes"
  homepage "https:github.comkritzikratziOscilloscope"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Oscilloscope.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.sd.oscilloscope",
    "~LibraryContainersorg.sd.oscilloscope",
  ]
end