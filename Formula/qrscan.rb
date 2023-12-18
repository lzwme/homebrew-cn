class Qrscan < Formula
  desc "Scan a QR code in the terminal using the system camera or a given image"
  homepage "https:github.comsayanarijitqrscan"
  url "https:github.comsayanarijitqrscanreleasesdownloadv0.1.9qrscan-0.1.9-x86_64-apple-darwin.tar.gz"
  sha256 "83e27a8731f17f8b91725435a406e6d165fded314db2b1231f7f39aaf802b782"

  def install
    bin.install "qrscan"
  end
end