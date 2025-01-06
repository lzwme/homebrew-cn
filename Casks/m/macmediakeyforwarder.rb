cask "macmediakeyforwarder" do
  version "3.1.2"
  sha256 "3e2c8ae7fbc9190e9c7528a3c4799ae42e6a33ddaf27f5cf01e141a0b9d6cd04"

  url "https:github.comquentinlescellermacmediakeyforwarderreleasesdownloadv#{version}MacMediaKeyForwarder.zip"
  name "Mac Media Key Forwarder"
  desc "Media key forwarder for iTunes and Spotify"
  homepage "https:github.comquentinlescellermacmediakeyforwarder"

  depends_on macos: ">= :mojave"

  app "MacMediaKeyForwarder.app"

  zap trash: "~LibraryPreferencescom.milgra.hsmke.plist"
end