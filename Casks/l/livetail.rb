cask "livetail" do
  version "2.1"
  sha256 "fd8b3d8521c4be647c8cbb85d02f659d547f2c8825bd3d270e44d0401c4197fa"

  url "https://ghfast.top/https://github.com/SumoLogic/livetail-cli/releases/download/#{version}/livetail_mac_os.zip"
  name "Sumologic livetail CLI"
  homepage "https://github.com/SumoLogic/livetail-cli"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-10-30", because: :unmaintained

  binary "livetail"

  caveats do
    requires_rosetta
  end
end