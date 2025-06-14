cask "comma-chameleon" do
  version "0.5.2"
  sha256 "be08b2088d4065f797d8943ee213882779f99d7130467ed73d0f4d5b73dc02fb"

  url "https:github.comtheodicomma-chameleonreleasesdownload#{version}Comma.Chameleon-darwin-x64.zip",
      verified: "github.comtheodicomma-chameleon"
  name "Comma Chameleon"
  desc "CSV editor"
  homepage "https:comma-chameleon.io"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-08-19", because: :discontinued

  app "Comma Chameleon-darwin-x64Comma Chameleon.app"

  caveats do
    requires_rosetta
  end
end