cask "fossa" do
  version "3.9.30"
  sha256 "b0774651cf7bc8ada41f8d8d2e35675de1b2c50546fe655f20b7a9ff9d0881c8"

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