cask "comictagger" do
  version "1.5.5"
  sha256 "dffa4fc8da1a1e5fb189d0259f9f6798367514241f81752670fa2e0254508223"

  url "https://ghfast.top/https://github.com/davide-romanini/comictagger/releases/download/#{version}/ComicTagger-#{version}-osx-10.15.7-x86_64.app.zip"
  name "ComicTagger"
  desc "Metadata editor for digital comics"
  homepage "https://github.com/davide-romanini/comictagger"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "ComicTagger.app"

  zap trash: [
    "~/.ComicTagger",
    "~/Library/Preferences/ComicTagger.plist",
    "~/Library/Saved Application State/ComicTagger.savedState",
  ]

  caveats do
    requires_rosetta
  end
end