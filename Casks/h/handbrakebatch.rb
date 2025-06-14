cask "handbrakebatch" do
  version "2.25"
  sha256 "d5f57d1a7ef9a85b32c800aa8c94ea73420940b6a9e463561df343fe82c64c6c"

  url "https://osomac.com/appcasts/handbrakebatch/HandBrakeBatch_#{version}.zip"
  name "HandBrakeBatch"
  homepage "https://osomac.com/apps/osx/handbrake-batch/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "HandBrakeBatch.app"
end