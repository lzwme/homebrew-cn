class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.2.tar.xz"
  sha256 "822f1f7c4059e8420387c302bd603cc0eb8cbfe403fa2e3f78c8ddb7f0d53bbc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "3802fda16ebf84708a7db2e132b898e22f39de00df6a441d5fbc2c488b89f8ab"
    sha256 x86_64_linux: "35ca044f907a3b7e1d9dff86f87924a5a772e63c7c4090c76dafbfeb49453440"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "ncurses"
  depends_on "readline"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    system "./configure", "--disable-silent-rules",
                          "--with-python-bin=#{venv.root}/bin/python3",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end