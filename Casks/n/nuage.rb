cask "nuage" do
  version "0.0.8"
  sha256 "6456f7969414e6dd1350d494e05ea92152ccc6d4c28faf5a2a6df6ba92ab6301"

  url "https:github.comlbrndnrnuage-macosreleasesdownloadv#{version}Nuage.app.zip"
  name "Nuage"
  desc "Free and open-source SoundCloud client"
  homepage "https:github.comlbrndnrnuage-macos"

  depends_on macos: ">= :ventura"

  app "Nuage.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterNuage*.plist",
    "~LibraryCachesch.laurinbrandner.nuage",
    "~LibraryContainersch.laurinbrandner.nuage",
    "~LibraryLogsDiagnosticReportsNuage*.crash",
    "~LibraryPreferencesch.laurinbrandner.nuage.plist",
  ]
end