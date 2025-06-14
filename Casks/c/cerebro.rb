cask "cerebro" do
  version "0.11.0"
  sha256 "9c26a044f6ae0d7c4f1df8056b88ff5014edb168d4cc13e00f0cad21948359fd"

  url "https:github.comcerebroappcerebroreleasesdownloadv#{version}cerebro-#{version}.dmg",
      verified: "github.comcerebroappcerebro"
  name "Cerebro"
  desc "Open-source launcher"
  homepage "https:cerebroapp.vercel.app"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Cerebro.app"

  uninstall quit: "cerebro"

  zap trash: [
    "~LibraryApplication SupportCerebro",
    "~LibraryPreferencescom.cerebroapp.Cerebro.helper.plist",
    "~LibraryPreferencescom.cerebroapp.Cerebro.plist",
    "~LibrarySaved Application Statecom.cerebroapp.Cerebro.savedState",
  ]

  caveats do
    requires_rosetta
  end
end