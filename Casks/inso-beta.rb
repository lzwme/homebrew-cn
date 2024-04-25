cask "inso-beta" do
  version "9.0.0-beta.5"
  sha256 "ef022cfb82a756bbdf0f7cd10b5ed5567205a19bf4bb802adda2db1402f6c0bf"

  url "https:github.comKonginsomniareleasesdownloadlib%40#{version}inso-macos-#{version}.zip",
      verified: "github.comKonginsomnia"
  name "inso"
  desc "CLI HTTP and GraphQL Client"
  homepage "https:insomnia.restproductsinso"

  livecheck do
    url "https:github.comKonginsomniareleases?q=prerelease%3Atrue+Inso+CLI"
    regex(%r{href=["']?[^"' >]*?taglib%40([^"' >]+?)["' >]}i)
    strategy :page_match
  end

  conflicts_with cask: "inso"

  binary "inso"

  # No zap stanza required
end