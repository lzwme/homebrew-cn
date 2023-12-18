cask "bob" do
  version "0.10.3"
  sha256 "2e3ff79c0a7f7090ba17382d0e76a1299291d58bd97a3e4816b7eac3f020948d"

  url "https:github.comripperheBobreleasesdownloadv#{version}Bob.zip"
  name "Bob"
  desc "Translation application for text, pictures, and manual input"
  homepage "https:github.comripperheBob"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Bob.app"

  zap trash: [
    "~LibraryApplication Supportcom.ripperhe.Bob",
    "~LibraryCachescom.ripperhe.Bob",
    "~LibraryHTTPStoragescom.ripperhe.Bob",
    "~LibraryPreferencescom.ripperhe.Bob.plist",
  ]
end