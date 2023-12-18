cask "nanoem" do
  version "34.10.0"
  sha256 "dd38a010648f9e5cc2b9d319dc5989527134d3482f55d80e6ab012b576af6a2c"

  url "https:github.comhkrnnanoemreleasesdownloadv#{version}nanoem-v#{version}-macos.zip"
  name "nanoem"
  desc "Cross-platform MMD (MikuMikuDance) compatible implementation"
  homepage "https:github.comhkrnnanoem"

  container nested: "nanoem-v#{version}-Darwin.dmg"

  app "nanoem.app"

  zap trash: [
    "~LibraryApplication Supportcom.github.nanoem",
    "~LibraryCachescom.github.nanoem",
    "~LibraryHTTPStoragescom.github.nanoem",
    "~LibraryPreferencescom.github.nanoem.plist",
    "~LibrarySaved Application Statecom.github.nanoem.savedState",
  ]
end