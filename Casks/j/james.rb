cask "james" do
  version "2.1.2"
  sha256 "6f958fcd988eccbfa9aacb393b7b5f484a3c824f2f137f948dfc5a82d8a9c962"

  url "https:github.comjames-proxyjamesreleasesdownloadv#{version}james-#{version}.dmg"
  name "James"
  desc "Web Debugging Proxy Application"
  homepage "https:github.comjames-proxyjames"

  app "James.app"

  caveats do
    requires_rosetta
  end
end