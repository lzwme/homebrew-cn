cask "ckan" do
  version "1.36.0"
  sha256 "ce6f648e2b94792e08633c20d9635142c3751bc7c459ba7b769c0fb6b971f4b8"

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