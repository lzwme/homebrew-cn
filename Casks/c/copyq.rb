cask "copyq" do
  arch arm: "12-m1", intel: "10"

  version "10.0.0"
  sha256 arm:   "f535cc45a1df777643fe47200c206b3a9d461b7b58869b1783ab7de1c95eccdc",
         intel: "5565ba19d59ab2bd4c54bb023dbf3fdf2b80b9706b25bc2021358f65c0cde5d4"

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