cask "millie" do
  version "2.8.0"
  sha256 "fff6fcd9f58c14c92419b1fcf8b02c51933fe09a64690def103bd5322c0afc00"

  url "https://install.millie.co.kr/flutter/#{version}/millie.dmg"
  name "Millie"
  desc "Korean e-book store"
  homepage "https://www.millie.co.kr/"

  livecheck do
    url "https://install.millie.co.kr/flutter/flutter_desktop_version.json"
    strategy :json do |json|
      json.dig("min", "macos")
    end
  end

  depends_on macos: ">= :big_sur"

  app "Millie.app"

  zap trash: [
    "~/Library/Application Support/kr.co.millie.MillieShelf",
    "~/Library/Caches/kr.co.millie.MillieShelf",
    "~/Library/HTTPStorages/kr.co.millie.MillieShelf.binarycookies",
    "~/Library/Saved Application State/kr.co.millie.MillieShelf.savedState",
    "~/Library/WebKit/kr.co.millie.MillieShelf",
  ]
end