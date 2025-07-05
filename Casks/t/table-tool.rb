cask "table-tool" do
  version "1.2.1"
  sha256 "e405f5aff5b74a8bb57f9e7dbc483a47d9c7d3d2ef095728d04e030e84017de1"

  url "https://ghfast.top/https://github.com/jakob/TableTool/releases/download/v#{version}/tabletool-#{version}.zip"
  name "Table Tool"
  desc "CSV file editor"
  homepage "https://github.com/jakob/TableTool"

  no_autobump! because: :requires_manual_review

  app "Table Tool.app"

  zap trash: [
    "~/Library/Application Scripts/at.eggerapps.tabletool",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/at.eggerapps.tabletool.sfl*",
    "~/Library/Containers/at.eggerapps.tabletool",
  ]

  caveats do
    requires_rosetta
  end
end