cask "vapor" do
  arch arm: "M1", intel: "x86"

  version "3.9.1"
  sha256 arm:   "dbb552c55cbe1dcbef4736ef3c4dbcabc2d7d1572406ee5d9f5b64fc480c1fa8",
         intel: "601ae6e9bd8b8bc82f2e6900b6522e1383e77e22f329267eb78f2059a7c1ee2d"

  url "https:github.comNCARVAPORreleasesdownloadv#{version}VAPOR#{version.major}-#{version}-Darwin#{arch}.dmg"
  name "VAPOR"
  desc "Visualization and analysis platform"
  homepage "https:github.comNCARVAPOR"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "vapor.app"

  zap trash: [
    "~.vapor3_settings",
    "~LibrarySaved Application StateVapor3.savedState",
  ]
end