cask "fossa" do
  version "3.9.24"
  sha256 "4717c1128f1e6873177975f4114e180b52e919ef1591a9ccd63636e47b23f3e4"

  url "https:github.comfossasfossa-clireleasesdownloadv#{version}fossa_#{version}_darwin_amd64.zip",
      verified: "github.comfossasfossa-cli"
  name "fossa"
  desc "Zero-configuration polyglot dependency analysis tool"
  homepage "https:fossa.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "fossa"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end