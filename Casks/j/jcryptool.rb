cask "jcryptool" do
  version "1.0.9"
  sha256 "58ba00b265e0180eb3e68f82a8978603fe1112af88ff747959e35bd11b9d79ee"

  url "https:github.comjcryptoolcorereleasesdownload#{version}JCrypTool-#{version}-macOS-64bit.tar.gz",
      verified: "github.comjcryptoolcore"
  name "JCrypTool"
  desc "Apply and analyze cryptographic algorithms"
  homepage "https:www.cryptool.orgenjctdownloads"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "JCrypTool.app"

  caveats do
    depends_on_java "11"
    requires_rosetta
  end
end