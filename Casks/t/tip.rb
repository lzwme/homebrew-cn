cask "tip" do
  version "2.0.0"
  sha256 "4d986a461d1b24bb5776fb49063b9a1891939f336b306a6bc75f58d0a4e98bcb"

  url "https:github.comtanin47tipreleasesdownloadv#{version}Tip.zip"
  name "Tip"
  desc "Programmable tooltip that can be used with any app"
  homepage "https:github.comtanin47tip"

  app "Tip.app"

  zap trash: "~LibraryApplication Scriptstanin.tip"
end