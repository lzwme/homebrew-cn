cask "gas-mask" do
  version "0.8.6"
  sha256 "9f75d0b11340d70832f87011c3d8ed97b9b18b3a56dec5f860d4040bb7404500"

  url "https:github.com2ndalphagasmaskreleasesdownload#{version}gas_mask_#{version}.zip"
  name "Gas Mask"
  desc "Hosts file editormanager"
  homepage "https:github.com2ndalphagasmask"

  auto_updates true

  app "Gas Mask.app"

  uninstall quit: "ee.clockwise.gmask"

  zap trash: [
    "~LibraryCachescom.apple.helpdGeneratedGas Mask Help*",
    "~LibraryCachesee.clockwise.gmask",
    "~LibraryGas Mask",
    "~LibraryLogsGas Mask.log",
    "~LibraryPreferencesee.clockwise.gmask.plist",
  ]

  caveats do
    requires_rosetta
  end
end