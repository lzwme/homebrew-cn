cask "jbrowse" do
  version "1.16.11"
  sha256 "bb143112ed8a7ff16548d57d95faa91a5f33ab44d75db0c1790ba7bf27da0272"

  url "https:github.comGMODjbrowsereleasesdownload#{version}-releaseJBrowse-#{version}-desktop-darwin-x64.zip",
      verified: "github.comGMODjbrowse"
  name "jbrowse"
  desc "Genome browser"
  homepage "https:jbrowse.org"

  app "JBrowse-#{version}-desktop-darwin-x64JBrowse-#{version}-desktop.app"
end