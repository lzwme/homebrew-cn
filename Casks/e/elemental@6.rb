cask "elemental@6" do
  version "6.9.1"
  sha256 "3512a5e33e55289f58b0ca83f0d4fae047e90ca2fb613f93118f3783d97434bd"

  url "https://ghfast.top/https://github.com/evolvedbinary/elemental/releases/download/elemental-#{version}/elemental-#{version}.dmg",
      verified: "github.com/evolvedbinary/elemental/"
  name "elemental"
  desc "Native XML Database with XQuery and XSLT"
  homepage "https://www.elemental.xyz/"

  livecheck do
    url :url
    regex(/^elemental[._-]v?(6(?:\.\d+)+)$/i)
  end

  depends_on :macos

  app "Elemental.app"

  zap trash: "~/Library/Application Support/xyz.elemental"

  caveats do
    depends_on_java "8"
  end
end