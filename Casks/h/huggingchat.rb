cask "huggingchat" do
  version "0.7.0"
  sha256 "b421090d0e68230b7fc2dc086bb12b1e846acce0682af45edc26e66b4be15ce1"

  url "https:github.comhuggingfacechat-macOSreleasesdownloadv#{version}HuggingChat.zip"
  name "HuggingChat"
  desc "Chat client for models on HuggingFace"
  homepage "https:github.comhuggingfacechat-macOS"

  depends_on macos: ">= :sonoma"

  app "HuggingChat.app"

  zap trash: [
    "~LibraryApplication Scriptscyrilzakka.HuggingChat-Mac",
    "~LibraryCachescyrilzakka.HuggingChat-Mac",
    "~LibraryContainerscyrilzakka.HuggingChat-Mac",
    "~LibraryHTTPStoragescyrilzakka.HuggingChat-Mac",
    "~LibraryHTTPStoragescyrilzakka.HuggingChat-Mac.binarycookies",
    "~LibraryPreferencescyrilzakka.HuggingChat-Mac.plist",
  ]
end