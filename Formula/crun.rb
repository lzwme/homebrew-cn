class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghproxy.com/https://github.com/containers/crun/releases/download/1.8.2/crun-1.8.2.tar.xz"
  sha256 "7f1916d9617d57d2e1699f7d771300418749d8b136322e8a2e22551b60f63a81"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92f26b648760702c3cb90ef90c35900fbe6de59b6360a4a258e137a28f92e298"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "go-md2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build

  depends_on "libcap"
  depends_on "libseccomp"
  depends_on :linux
  depends_on "systemd"
  depends_on "yajl"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --rootless=true list -q").strip
  end
end