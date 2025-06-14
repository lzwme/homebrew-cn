cask "controlplane" do
  version "1.6.7"
  sha256 "beb444b8117ed91898921a6babc384501dfd92679f5b718fceb6d3aa7a0bf651"

  url "https:github.comdustinrueControlPlanereleasesdownload#{version}ControlPlane-#{version}.dmg",
      verified: "github.comdustinrueControlPlane"
  name "ControlPlane"
  desc "Context-sensitive application launcher"
  homepage "https:www.controlplaneapp.com"

  no_autobump! because: :requires_manual_review

  # app crash and homepage is gone
  deprecate! date: "2023-12-29", because: :discontinued
  disable! date: "2024-12-30", because: :discontinued

  app "ControlPlane.app"

  zap trash: "~LibraryPreferencescom.dustinrue.ControlPlane.plist"
end