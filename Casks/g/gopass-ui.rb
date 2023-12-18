cask "gopass-ui" do
  version "0.8.0"
  sha256 "90d359d6d8936a924f0f0d1c5f194cbf1571c4ef5cf67b3ee853f2676aa83549"

  url "https:github.comcodecentricgopass-uireleasesdownloadv#{version}Gopass.UI-#{version}.dmg"
  name "Gopass UI"
  desc "Password manager for teams"
  homepage "https:github.comcodecentricgopass-ui"

  app "Gopass UI.app"

  zap trash: "~.configgopass"
end