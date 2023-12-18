cask "bloomrpc" do
  version "1.5.3"
  sha256 "9ddc4d9b85af745a5f5e49a55e9dd4d57e09855aee721f77e2a3151744cbc3ad"

  url "https:github.comuw-labsbloomrpcreleasesdownload#{version}BloomRPC-#{version}.dmg"
  name "BloomRPC"
  desc "GUI Client for GRPC Services"
  homepage "https:github.comuw-labsbloomrpc"

  app "BloomRPC.app"

  zap trash: "~LibraryPreferencesio.github.utilitywarehouse.BloomRPC.plist"

  caveats do
    discontinued
  end
end