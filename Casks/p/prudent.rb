cask "prudent" do
  version "29"
  sha256 "375970eadf59bab17e8add0057ea967b0376eb1385889d5b64f84a720e4dd4cb"

  url "https:github.comPrudentMemainreleasesdownload#{version}Prudent.zip",
      verified: "github.comPrudentMemain"
  name "Prudent"
  desc "Integrated environment for your personal and family ledger"
  homepage "https:prudent.me"

  app "Prudent.app"

  caveats do
    requires_rosetta
  end
end