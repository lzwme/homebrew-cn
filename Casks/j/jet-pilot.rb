cask "jet-pilot" do
  arch arm: "aarch64", intel: "x64"

  version "1.33.0"
  sha256  arm:   "6f2c1ea91c3728660df02ee03d61ce5027dc480e722f13b46337feae76de30bf",
          intel: "9a8bba082f87b9426d6e69e7d251d80ddcd54c74b05ecca0d61dd5a49ab05e43"

  url "https:github.comunxsistjet-pilotreleasesdownloadv#{version}JET.Pilot_#{version}_#{arch}.dmg",
      verified: "github.comunxsistjet-pilot"
  name "JET Pilot"
  desc "Kubernetes desktop client"
  homepage "https:www.jet-pilot.app"

  livecheck do
    url "https:updates.jet-pilot.applatest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "JET Pilot.app"

  zap trash: "~LibraryApplication Supportcom.unxsist.jetpilot"
end