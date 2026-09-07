class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://ghfast.top/https://github.com/phaag/nfdump/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "cd15a3e0e0ec0b34c8dfc0c3202ce0d63a09a78341f533f3cbe8d69833927bbf"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05ee1bd6b2a1bd4c9b0d488cb0e8ac86a55e9640d750eb40864a9db9c0d585d0"
    sha256 cellar: :any, arm64_sequoia: "fa42cb83546f268792643ac7e5b21991be5ea64b4554dc8ceabb5b12cc442c58"
    sha256 cellar: :any, arm64_sonoma:  "6330d4889cae75c1d43f8dae547bdf1de16a81a0b876aa9311f6f85c7446c2cb"
    sha256 cellar: :any, arm64_linux:   "43ac22f0f2bf15ff28c6a38411637f57e2396a0163524a3624ccd5d62c90cd53"
    sha256 cellar: :any, x86_64_linux:  "c617f1b4ac5e747cc1f472fb5ffde80a8207e64d24c4142d1d2a92319ea39cfe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end