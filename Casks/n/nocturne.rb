cask "nocturne" do
  version "3.0"
  sha256 "895ac0c5493b3877cf1cc6d62dfb5c0fee3c6bd41d44bd3c87554e52a0cf1462"

  url "https:github.comDaij-DjannocturneblobmasterDist#{version}.zip?raw=true"
  name "Nocturne"
  desc "Adjust display colors to suit low light conditions"
  homepage "https:github.comDaij-Djannocturne"

  livecheck do
    url :homepage
    regex(%r{href=.*?nocturneblobmasterDistv?(\d+(?:\.\d+)+)\.zip}i)
    strategy :page_match
  end

  app "Nocturne.app"
end