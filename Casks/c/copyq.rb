cask "copyq" do
  arch arm: "12-m1", intel: "10"

  version "9.1.0"
  sha256 arm:   "56771f7be5bec04a8e3b8c01cebb0123f27fe0dddbaa624a35f5f4793e893af8",
         intel: "4ca36fd7387ccf54572f65eb33f4b7db07d06533c4ccd8c7888e21c02d54708d"

  url "https:github.comhlukCopyQreleasesdownloadv#{version}CopyQ-macos-#{arch}.dmg.zip",
      verified: "github.comhlukCopyQ"
  name "CopyQ"
  desc "Clipboard manager with advanced features"
  homepage "https:hluk.github.ioCopyQ"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "CopyQ.app"

  zap trash: [
    "~.configcopyq",
    "~LibraryApplication Supportcopyq",
    "~LibraryApplication Supportcopyq.log",
    "~LibraryPreferencescom.copyq.copyq.plist",
  ]

  caveats do
    unsigned_accessibility
  end
end