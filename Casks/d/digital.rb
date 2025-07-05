cask "digital" do
  version "0.31"
  sha256 "12f014c8b99140554f8f7464ebc771bbe3de6af39c83c20463492bcb892afc69"

  url "https://ghfast.top/https://github.com/hneemann/Digital/releases/download/v#{version}/Digital.zip"
  name "Digital"
  desc "Logic designer and circuit simulator"
  homepage "https://github.com/hneemann/Digital"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  suite "Digital"

  zap trash: "~/.digital.cfg"

  caveats do
    depends_on_java "8+"
  end
end