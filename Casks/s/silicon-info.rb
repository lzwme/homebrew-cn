cask "silicon-info" do
  version "1.0.3"
  sha256 "ada6ba4665e2aa2973e2faef59f312cc82ae689505236c4c2d412bc3ae18d0f9"

  url "https:github.combillycastelliSilicon-Inforeleasesdownload#{version}Silicon.Info.app.zip"
  name "Silicon Info"
  desc "View the architecture of the running application"
  homepage "https:github.combillycastelliSilicon-Info"

  depends_on macos: ">= :big_sur"

  app "Silicon Info.app"

  zap trash: [
    "~LibraryApplication Scriptscom.wcastelli.silicon-info",
    "~LibraryContainerscom.wcastelli.silicon-info",
  ]
end