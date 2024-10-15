cask "messenger-native" do
  version "1.0.0"
  sha256 "72d730197b91963a5804adf09cbb2a4df3d9374f0ec922035e34587d0e2c073a"

  url "https:github.comgastonmorixeMessengerNativereleasesdownload#{version}Mac64_MessengerNative#{version}.zip"
  name "Messenger Native"
  desc "Facebook's Messenger Native"
  homepage "https:github.comgastonmorixeMessengerNative"

  deprecate! date: "2024-10-14", because: :unmaintained

  app "osx64Messenger Native.app"

  caveats do
    requires_rosetta
  end
end