class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghproxy.com/https://github.com/containers/crun/releases/download/1.11/crun-1.11.tar.xz"
  sha256 "ebd24a99a3c6b86296bd510fbb8d6bcb0c3246940feeb767beaf5b9b69cec62e"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9abf12c8301df00670aa1d6eca1f09677e8f011cbb01f8892e61550226c049ae"
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
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_empty shell_output("#{bin}/crun --rootless=true list -q").strip
  end
end