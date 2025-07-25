class Crun < Formula
  desc "Fast and lightweight fully featured OCI runtime and C library"
  homepage "https://github.com/containers/crun"
  url "https://ghfast.top/https://github.com/containers/crun/releases/download/1.23/crun-1.23.tar.zst"
  sha256 "e8d3744e8b7391efa438fbd45b5e2c8532f39df98e8e810ea90671d85f467f5b"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1e896db5b7fc73eb21ead83e7a2f62ce03104e14b3ab0b308d428e0bd7745bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53ebd3bb62b3d088af6cc48ac608c77d97e10671e2b63f246c33f953abdc856b"
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