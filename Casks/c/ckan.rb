cask "ckan" do
  version "1.35.2"
  sha256 "e74ce242a3cdd05d3d2aac8134237241c65e62772700043da53985b3a8306ce7"

  url "https:github.comKSP-CKANCKANreleasesdownloadv#{version}CKAN.dmg"
  name "Comprehensive Kerbal Archive Network"
  desc "Mod management solution for Kerbal Space Program"
  homepage "https:github.comKSP-CKANCKAN"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "mono-mdk"

  app "CKAN.app"

  zap trash: "~.localshareCKAN"
end