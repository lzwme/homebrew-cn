cask "controlplane" do
  version "1.6.7"
  sha256 "beb444b8117ed91898921a6babc384501dfd92679f5b718fceb6d3aa7a0bf651"

  url "https:github.comdustinrueControlPlanereleasesdownload#{version}ControlPlane-#{version}.dmg",
      verified: "github.comdustinrueControlPlane"
  name "ControlPlane"
  homepage "https:www.controlplaneapp.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ControlPlane.app"

  zap trash: "~LibraryPreferencescom.dustinrue.ControlPlane.plist"
end