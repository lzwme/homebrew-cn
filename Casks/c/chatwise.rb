cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.78"
  sha256 arm:   "97af46b19dc323b3296b5a29439738a3fad91f3c21c821254a3e9a7277b9108d",
         intel: "d58e6461584e492e4094165c788ff4993f7c3c16b6bb9a28bda760ff956276b2"

  url "https://ghfast.top/https://github.com/egoist/chatwise-releases/releases/download/v#{version}/ChatWise_#{version}_#{arch}.dmg",
      verified: "github.com/egoist/chatwise-releases/"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https://chatwise.app/"

  livecheck do
    url "https://chatwise.app/api/trpc/getReleases"
    strategy :json do |json|
      json.dig("result", "data")&.map { |item| item["tag"]&.tr("v", "") }
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~/Library/Application Support/app.chatwise",
    "~/Library/Caches/app.chatwise",
    "~/Library/Saved Application State/app.chatwise.savedState",
    "~/Library/WebKit/app.chatwise",
  ]
end