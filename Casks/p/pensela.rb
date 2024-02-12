cask "pensela" do
  version "1.2.5"
  sha256 "f6029a8a876038835c9045e75a05367f4f6f63e7ff6a9f11e4921a0ef9559c6b"

  url "https:github.comweiameiliPenselareleasesdownloadv#{version}Pensela-#{version}.dmg"
  name "Pensela"
  desc "Screen Annotation Tool"
  homepage "https:github.comweiameiliPensela"

  deprecate! date: "2024-02-11", because: :discontinued

  app "Pensela.app"

  zap trash: [
    "~LibraryApplication Supportpensela",
    "~LibraryPreferencescom.wali.Pensela.plist",
    "~LibrarySaved Application Statecom.wali.Pensela.savedState",
  ]
end