class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https:github.comcontainerscrun"
  url "https:github.comcontainerscrunreleasesdownload1.18.1crun-1.18.1.tar.zst"
  sha256 "86a693d0005a00927c0621f6e726a12abff0a129b0cc81a48d4d22dc990528a5"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4fbaa25803496d07b5259ecc776681d9e9b6b8ea40a346c6ab019d08ad9a4a27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system ".autogen.sh"
    system ".configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}crun --rootless=true list -q").strip
  end
end