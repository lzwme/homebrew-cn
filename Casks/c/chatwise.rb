cask "chatwise" do
  arch arm: "arm64", intel: "x64"

  version "26.4.16"
  sha256 arm:   "f6d57180817b1a40c807818ad612bc5230c74dc952c9d6cbea633e39683a1d8e",
         intel: "02b254301cd04aa247a68d06758e9cc7ad1d3402d802f792378f0cc81b4f3ec4"

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