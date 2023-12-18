cask "cornercal" do
  version "1.1"
  sha256 "391f5039d74d3b789d8fec7afbd045c98a0f0148c60ff8802000eacc9af0a781"

  url "https:github.comekreutzCornerCalblobv#{version}buildsCornerCal.zip?raw=true"
  name "CornerCal"
  homepage "https:github.comekreutzCornerCal"

  depends_on macos: ">= :sierra"

  app "CornerCal.app"
end