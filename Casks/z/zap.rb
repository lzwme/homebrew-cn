cask "zap" do
  arch arm: "_aarch64"

  version "2.15.0"
  sha256 arm:   "4426253f4702bbd5fb4779bcf4d62490b2c10ec851c4ebc94ced8f156d2e5509",
         intel: "ae025403e46cdefff013cd0c3b88d8edc5a183a76daa63cb62c7c629005337a5"

  url "https:github.comzaproxyzaproxyreleasesdownloadv#{version}ZAP_#{version}#{arch}.dmg",
      verified: "github.comzaproxyzaproxy"
  name "Zed Attack Proxy"
  name "ZAP"
  desc "Free and open source web app scanner"
  homepage "https:www.zaproxy.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ZAP.app"

  zap trash: [
    "~LibraryApplication SupportZAP",
    "~LibraryPreferencesorg.zaproxy.zap.plist",
  ]
end