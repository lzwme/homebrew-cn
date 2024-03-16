cask "aware" do
  version "1.1.0"
  sha256 "65876e04bcf1915ccf917ebaf5ec99ca5ae8ba5fc50011144a47bfbadb23e060"

  url "https:github.comjoshAwarereleasesdownloadv#{version}Aware.zip",
      verified: "github.comjoshAware"
  name "Aware"
  desc "Menubar app to track active computer use"
  homepage "https:awaremac.com"

  depends_on macos: ">= :ventura"

  app "Aware.app"
end