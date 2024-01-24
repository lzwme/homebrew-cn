cask "fossa" do
  version "3.8.32"
  sha256 "c268083810814a995e89c73b54b0ab4fa810b3dacec61fd1c1c4a6e6ac0c74cf"

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