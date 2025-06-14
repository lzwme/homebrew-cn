cask "corelocationcli" do
  version "4.0.4"
  sha256 "6b76a809f6fa747c60d47c18588677f053d870c5f0db326c5da309a3956b7d94"

  url "https:github.comfulldecentcorelocationclireleasesdownload#{version}CoreLocationCLI.zip"
  name "Core Location CLI"
  desc "Prints location information from CoreLocation"
  homepage "https:github.comfulldecentcorelocationcli"

  no_autobump! because: :requires_manual_review

  app "CoreLocationCLI.app"
  binary "#{appdir}CoreLocationCLI.appContentsMacOSCoreLocationCLI"

  # no zap stanza required
end