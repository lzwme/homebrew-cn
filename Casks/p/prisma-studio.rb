cask "prisma-studio" do
  version "0.458.0"
  sha256 "00dd82a9f8ab8f193f4d60b635edaac9f75b341f53c1ca0957efd898db1ba952"

  url "https:github.comprismastudioreleasesdownloadv#{version}Prisma-Studio.dmg",
      verified: "github.comprismastudio"
  name "Prisma Studio"
  desc "Visual database editor for Prisma projects"
  homepage "https:www.prisma.iostudio"

  no_autobump! because: :requires_manual_review

  app "Prisma Studio.app"

  zap trash: [
    "~LibraryApplication SupportPrisma Studio",
    "~LibraryLogsPrisma Studio",
    "~LibraryPreferencesio.prisma.studio.plist",
    "~LibrarySaved Application Stateio.prisma.studio.savedState",
  ]

  caveats do
    requires_rosetta
  end
end