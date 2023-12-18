cask "biscuit" do
  arch arm: "-arm64"

  version "1.2.29"
  sha256 arm:   "75a92e65c7cc8be6296abf6e85dc4feb5c8314df4e0971cd4ab24549eef445ed",
         intel: "a869a9907fb8da48372a4da2b300a5660b6e11bf460d473821ca0a3b096eb4ea"

  url "https:github.comagatadl.biscuitreleasesdownloadv#{version}Biscuit-#{version}#{arch}.dmg",
      verified: "github.comagatadl.biscuit"
  name "Biscuit"
  desc "Browser to organise apps"
  homepage "https:eatbiscuit.com"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Biscuit.app"

  zap trash: [
    "~LibraryApplication Supportbiscuit",
    "~LibraryLogsBiscuit",
    "~LibraryPreferencescom.eatbiscuit.biscuit.plist",
    "~LibrarySaved Application Statecom.eatbiscult.biscult.savedState",
  ]
end