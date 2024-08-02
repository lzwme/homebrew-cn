class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https:github.comjohangbtfs"
  url "https:github.comjohangbtfsarchiverefstagsv2.24.tar.gz"
  sha256 "d71ddefe3c572e05362542a0d9fd0240d8d4e1578ace55a8b3245176e7fd8935"
  license "GPL-3.0-only"
  revision 1
  head "https:github.comjohangbtfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "440c3be8b9952616f1aa74044ff4aad74fe9a2ba8f584c7d650546b5ee129ac2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "libfuse@2"
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    ENV.cxx11
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin"btfs", "--help"
  end
end