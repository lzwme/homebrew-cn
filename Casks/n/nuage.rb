cask "nuage" do
  version "0.0.7"
  sha256 "d3dfe6670b46cd78522dbba33e40e4ee37ee0f056844d6b69b523d953a27bd3d"

  url "https:github.comlbrndnrnuage-macosreleasesdownloadv#{version}Nuage.app.zip"
  name "Nuage"
  desc "Free and open-source SoundCloud client"
  homepage "https:github.comlbrndnrnuage-macos"

  depends_on macos: ">= :big_sur"

  app "Nuage.app"

  zap trash: [
    "~LibraryApplication SupportCrashReporterNuage*.plist",
    "~LibraryCachesch.laurinbrandner.nuage",
    "~LibraryContainersch.laurinbrandner.nuage",
    "~LibraryLogsDiagnosticReportsNuage*.crash",
    "~Preferencesch.laurinbrandner.nuage.plist",
  ]
end