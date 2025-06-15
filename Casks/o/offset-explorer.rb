cask "offset-explorer" do
  version "3.0.3"
  sha256 :no_check

  url "https://www.kafkatool.com/download#{version.major}/offsetexplorer.dmg"
  name "Offset Explorer"
  name "Kafka Tool"
  desc "GUI for managing and using Apache Kafka clusters"
  homepage "https://www.kafkatool.com/index.html"

  livecheck do
    url "https://www.kafkatool.com/download.html"
    regex(/Offset\s*Explorer\s*v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  app "Offset Explorer #{version.major}.app"

  zap trash: "~/.kafkatool#{version.major}"
end