cask "pext" do
  version "0.35"
  sha256 "eab9c61d0a05b131bec175f08b7c5ef7e4aed07c90405f7b1b14ce8b4a11b605"

  url "https:github.comPextPextreleasesdownloadv#{version}Pext-#{version}.dmg",
      verified: "github.comPextPext"
  name "Pext"
  desc "Python-based extendable tool"
  homepage "https:pext.io"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-09-06", because: :discontinued

  app "Pext.app"
end