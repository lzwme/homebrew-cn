class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://ghproxy.com/https://github.com/pciutils/pciutils/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "e579d87f1afe2196db7db648857023f80adb500e8194c4488c8b47f9a238c1c6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "7c9e9637f605a3a053848a968060f098e7f2e1ed88f2aaa53c4dabf178b9b344"
  end

  depends_on :linux
  depends_on "zlib"

  def install
    args = ["ZLIB=yes", "DNS=yes", "SHARED=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"]
    system "make", *args
    system "make", "install", *args
    system "make", "install-lib", *args
  end

  test do
    assert_match "lspci version", shell_output("#{bin}/lspci --version")
    assert_match "Host bridge:", shell_output("#{bin}/lspci")
  end
end