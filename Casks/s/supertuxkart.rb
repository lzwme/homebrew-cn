cask "supertuxkart" do
  version "1.4"
  sha256 "21a7fb34132036c5810a8b48527513981d98d09d27d33b15e2f428bdc492c89d"

  url "https:github.comsupertuxkartstk-codereleasesdownload#{version}SuperTuxKart-#{version}-mac.zip",
      verified: "github.comsupertuxkartstk-code"
  name "SuperTuxKart"
  desc "Kart racing game"
  homepage "https:supertuxkart.netMain_Page"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "SuperTuxKart.app"

  zap trash: [
    "~LibraryApplication SupportSuperTuxKart",
    "~LibrarySaved Application Statenet.sourceforge.supertuxkart.savedState",
  ]
end