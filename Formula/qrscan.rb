class Qrscan < Formula
  desc "Scan a QR code in the terminal using the system camera or a given image"
  homepage "https://github.com/sayanarijit/qrscan"
  url "https://ghproxy.com/https://github.com/sayanarijit/qrscan/releases/download/v0.1.7/qrscan-0.1.7-x86_64-apple-darwin.tar.gz"
  sha256 "16311ee12a8655a6dd533c54b0d50a81b5aeadb551af7c9d0ee66a5f087dc881"

  def install
    bin.install "qrscan"
  end
end