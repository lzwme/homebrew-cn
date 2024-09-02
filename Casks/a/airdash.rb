cask "airdash" do
  version "2.0.155"
  sha256 "38c96e57d824479904fb9866d04f42c2179ac3c8f2cc85a7194b7ad914b4d376"

  url "https:github.comsimonbengtssonairdashreleasesdownloadv#{version}airdash.dmg",
      verified: "github.comsimonbengtssonairdash"
  name "AirDash"
  desc "Transfer photos and files to any device"
  homepage "https:airdash-project.web.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "AirDash#{version.patch}.app"

  zap trash: [
    "~LibraryApplication Scriptsio.flown.airdashn",
    "~LibraryContainersio.flown.airdashn",
  ]
end