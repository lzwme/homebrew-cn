cask "swift-shift" do
  version "0.26.0"
  sha256 "97b9b48af1e558b7b6635257a3b3d3d48fd87a1c2aef121adf5bf5d7fef198b6"

  url "https:github.compablopunkSwiftShiftreleasesdownload#{version}SwiftShift.zip",
      verified: "github.compablopunkSwiftShift"
  name "Swift Shift"
  desc "Window manager"
  homepage "https:www.swiftshift.app"

  livecheck do
    url "https:pablopunk.github.ioSwiftShiftappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Swift Shift.app"

  uninstall quit:       "com.pablopunk.Swift-Shift",
            login_item: "Swift Shift"

  zap trash: [
    "~LibraryHTTPStoragescom.pablopunk.Swift-Shift",
    "~LibraryPreferencescom.pablopunk.Swift-Shift.plist",
  ]
end