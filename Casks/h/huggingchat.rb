cask "huggingchat" do
  version "0.7.0"
  sha256 "6a9601d793f25dc62fe6cec9314a7a99d51106937d283c90fabd45e29f1d83e4"

  url "https:github.comhuggingfacechat-macOSreleasesdownloadv#{version}HuggingChat.zip"
  name "huggingchat"
  desc "Chat client for models on HuggingFace"
  homepage "https:github.comhuggingfacechat-macOS"

  depends_on macos: ">= :sonoma"

  app "HuggingChatHuggingChat.app"

  zap trash: [
    "~LibraryApplication Scriptscyrilzakka.HuggingChat-Mac",
    "~LibraryContainerscyrilzakka.HuggingChat-Mac",
  ]
end