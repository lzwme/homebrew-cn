cask "tla+-toolbox" do
  version "1.7.1"
  sha256 "78e7d0ecbcba63ef7f13f9f315bfb0365a4f1d952caaa11a0a6f86a1bae5ac99"

  url "https:github.comtlaplustlaplusreleasesdownloadv#{version}TLAToolbox-#{version}-macosx.cocoa.x86_64.zip",
      verified: "github.comtlaplustlaplus"
  name "TLA+ Toolbox"
  desc "IDE for TLA+"
  homepage "https:lamport.azurewebsites.nettlatoolbox.html"

  livecheck do
    url :homepage
    regex(%r{href=.*?github.comtlaplustlaplusreleasestagv?(\d+(?:\.\d+)+)[\s"]}i)
  end

  app "TLA+ Toolbox.app"

  caveats do
    requires_rosetta
  end
end