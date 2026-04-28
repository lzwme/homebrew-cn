cask "chatwise" do
  arch arm: "arm64", intel: "x64"

  version "26.4.17"
  sha256 arm:   "96dcdec275101bf08bc60b9800d89c162083d2a238991a158f75ca6749ef37f7",
         intel: "0c6e6bf46a57308248ab3f788ae86126886eed19837a235f253780430d6d8abe"

  url "https://releases.chatwise.app/#{version}/ChatWise-#{version}-#{arch}.dmg"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https://chatwise.app/"

  livecheck do
    url "https://releases.chatwise.app/releases"
    strategy :json do |json|
      json.map { |v| v["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~/Library/Application Support/app.chatwise",
    "~/Library/Caches/app.chatwise",
    "~/Library/Saved Application State/app.chatwise.savedState",
    "~/Library/WebKit/app.chatwise",
  ]
end