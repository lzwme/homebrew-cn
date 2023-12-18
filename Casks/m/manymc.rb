cask "manymc" do
  version "0.1.2"
  sha256 "5e230f3aca4e8b63b24b036b4175e55c2a3f49da68bdd8b05b9dc8ef823cc06d"

  url "https:github.comMinecraftMachinaManyMCreleasesdownloadv#{version}ManyMC.zip"
  name "ManyMC"
  desc "Minecraft launcher with native arm64 support"
  homepage "https:github.comMinecraftMachinaManyMC"

  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "ManyMC.app"

  zap trash: [
    "~LibraryApplication SupportManyMC",
    "~LibraryPreferencesorg.manymc.ManyMC.plist",
    "~LibraryPreferencesorg.multimc.ManyMC.plist",
    "~LibraryPreferencesorg.polymc.ManyMC.plist",
    "~LibrarySaved Application Stateorg.manymc.ManyMC.savedState",
    "~LibrarySaved Application Stateorg.multimc.ManyMC.savedState",
    "~LibrarySaved Application Stateorg.polymc.ManyMC.savedState",
  ]
end