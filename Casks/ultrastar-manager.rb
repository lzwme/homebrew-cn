cask "ultrastar-manager" do
  arch arm: "ARM", intel: "x86"

  version "2.0.0"
  sha256 arm:   "23b38629e5291ef17514f824aa8080441ead829769fd2b9a45ab544bf4210290",
         intel: "2818e9c0258360460ec1a6825770dc5a91962a30b081b64c6fe681153722fec6"

  url "https://ghfast.top/https://github.com/UltraStar-Deluxe/UltraStar-Manager/releases/download/#{version}/MAC-#{arch}-UltraStar-Manager.dmg"
  name "UltraStar Manager"
  desc "Manager application for UltraStar songs"
  homepage "https://github.com/UltraStar-Deluxe/UltraStar-Manager"

  livecheck do
    url :stable
  end

  app "UltraStarManager.app"
end