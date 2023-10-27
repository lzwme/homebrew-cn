class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://ghproxy.com/https://github.com/bstansell/conserver/releases/download/v8.2.7/conserver-8.2.7.tar.gz"
  sha256 "0607f2147a4d384f1e677fbe4e6c68b66a3f015136b21bcf83ef9575985273d8"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6070a08f377c33c31c8aea3edabfdeb4c9bdf830c6d4a6586ee44b0444d47eda"
    sha256 cellar: :any,                 arm64_ventura:  "74dc851dc7fbf69e4ef2dd38eb0d60f6741a16cb2a22d0d963d26aca9dc8c5ca"
    sha256 cellar: :any,                 arm64_monterey: "52680e8e2d323b4cde6de75a037d04e729c4321b238135ac58a7565fced2bd5b"
    sha256 cellar: :any,                 sonoma:         "ae11c71a862224b9c9543f9f7260ce46a4e99e217394686df0349ebe9535fd03"
    sha256 cellar: :any,                 ventura:        "6a0660b32b3125db2e2606e0bcbe3c1bb20b736d992965d23a833e51c584eca9"
    sha256 cellar: :any,                 monterey:       "17d0fb890c0930ee9754f6e9689b3b7f311172a163b43aa4d2722a25627257d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df28d58e8e82327adc6b6a0b60bd10f6d92d17eb918668a72ceea68ae8f952b"
  end

  depends_on "openssl@3"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6", "--with-gssapi", "--with-striprealm"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end