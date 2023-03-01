class Moul < Formula
  desc "The minimalist publishing tool for photographers"
  homepage "https://moul.app"
  url "https://ghproxy.com/https://github.com/moulco/moul/releases/download/3.2.3/moul_darwin_amd64.tar.gz"
  sha256 "84d1859089f356dbaefc889cacdc2f92e1a750287dc8d7ea57102ceaca78269d"

  def install
    mv "moul_darwin_amd64", "moul"
    bin.install "moul"
  end

  test do
    system "#{bin}/moul", "version"
  end
end