class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghfast.top/https://github.com/containers/crun/releases/download/1.23.1/crun-1.23.1.tar.zst"
  sha256 "6cea8d41e4be425ba2fa55587e16e44ddbe2fa333b367024e68235b922e26056"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fe682495a48fa0ba3ec701b385065a92faaa70cc0336bc74d5d03cc80d3a8252"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bcc1475a36dd4caacbda18bde7afb604ba5d57ed5d2e8549479a33b55be3af0d"
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
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --root=#{testpath} list -q").strip
  end
end