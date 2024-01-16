class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https:github.comcontainerscrun"
  url "https:github.comcontainerscrunreleasesdownload1.13crun-1.13.tar.xz"
  sha256 "0d9423a0860abaac8f796ec5d5efce5acbcb199480fa114314aa30172f0d133a"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a234afba1b1c94a72f9076cf15165c7385f23df825ee7cca01998d43fcb1987c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

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