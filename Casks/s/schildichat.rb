cask "schildichat" do
  version "1.11.30-sc.2"
  sha256 "0eb09b23fc9c9f49cb72243149a097291cf01a7f344ed830ab0ce2ccedcc0681"

  url "https:github.comSchildiChatschildichat-desktopreleasesdownloadv#{version}SchildiChat-#{version}-universal_by_nyantec.dmg",
      verified: "github.comSchildiChatschildichat-desktop"
  name "SchildiChat"
  desc "Matrix client based on Element with a more traditional IM experience"
  homepage "https:schildi.chatdesktop"

  deprecate! date: "2024-04-06", because: :discontinued
  disable! date: "2025-04-08", because: :discontinued

  app "SchildiChat.app"

  zap trash: "~LibraryApplication SupportSchildiChat"
end