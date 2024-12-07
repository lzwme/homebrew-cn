class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https:github.comcontainerscrun"
  url "https:github.comcontainerscrunreleasesdownload1.19crun-1.19.tar.zst"
  sha256 "26e66b385e1177d8b773686eb5d62db3bd618c51f63fba922878c76afff98880"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5fbdda8eceb08487d11ff2aa106020b04f8326fd650792d0ad13b11472624d63"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
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