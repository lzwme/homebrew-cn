cask "fossa" do
  version "3.8.31"
  sha256 "92b68056f1e84b261a4acabba53ccd226750e0a7f7a26c73d9557341300be415"

  url "https:github.comfossasfossa-clireleasesdownloadv#{version}fossa_#{version}_darwin_amd64.zip",
      verified: "github.comfossasfossa-cli"
  name "fossa"
  desc "Zero-configuration polyglot dependency analysis tool"
  homepage "https:fossa.com"

  binary "fossa"

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end