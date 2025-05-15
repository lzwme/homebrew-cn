cask "swift-shift" do
  version "0.27.1"
  sha256 "67678a07ea39783850e858bc0bc2c2c0a9a05b1ac665ba23b7e8ce46cdb0cfed"

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