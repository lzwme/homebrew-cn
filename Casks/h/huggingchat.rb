cask "huggingchat" do
  version "0.6.0"
  sha256 "14a264b02595bd2560d947091e92cea3b496a9e003db36059c1431efcf1b4fac"

  url "https:github.comhuggingfacechat-macOSreleasesdownloadv#{version}HuggingChat.zip"
  name "huggingchat"
  desc "Chat client for models on HuggingFace"
  homepage "https:github.comhuggingfacechat-macOS"

  depends_on macos: ">= :sonoma"

  app "HuggingChat.app"

  zap trash: [
    "~LibraryApplication Scriptscyrilzakka.HuggingChat-Mac",
    "~LibraryContainerscyrilzakka.HuggingChat-Mac",
  ]
end