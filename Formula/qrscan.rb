class Qrscan < Formula
  desc "Scan a QR code in the terminal using the system camera or a given image"
  homepage "https://github.com/sayanarijit/qrscan"
  url "https://ghproxy.com/https://github.com/sayanarijit/qrscan/releases/download/v0.1.8/qrscan-0.1.8-x86_64-apple-darwin.tar.gz"
  sha256 "634232bf798687ffddaccfd6c1136a521e290b48f1cb9f268ff7424291ec1b8f"

  def install
    bin.install "qrscan"
  end
end