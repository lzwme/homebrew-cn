class Liblxi < Formula
  desc "Simple C API for communicating with LXI compatible instruments"
  homepage "https://github.com/lxi-tools/liblxi"
  url "https://ghproxy.com/https://github.com/lxi-tools/liblxi/archive/refs/tags/v1.19.tar.gz"
  sha256 "94496b32fd544019dbca40b3f19fb03d186daf3b96857fb9cebed9124b4051d6"
  license "BSD-3-Clause"
  head "https://github.com/lxi-tools/liblxi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63bcb7e9f147d03a0d64312d8c163c69b0e7f16981abc5a9bbb7cc83e6bc3519"
    sha256 cellar: :any,                 arm64_monterey: "2365317da14265abfb1e2234b0f56eeb00c22e9b81f78d13ede32f315382d02e"
    sha256 cellar: :any,                 arm64_big_sur:  "aa692d16c6e2efe4256a321e87f8a1802d41425a9d7abb29efda7cdb79b86f4b"
    sha256 cellar: :any,                 ventura:        "f2e5e6d30a77edb1816d10122ec6e21fb344ff8259caf98fa9cd8911fa659337"
    sha256 cellar: :any,                 monterey:       "acfb74e8fc1865fb79b3c40fb8e4bca8562b3021ea99bedf251b2fdb97eeb4e3"
    sha256 cellar: :any,                 big_sur:        "db54fd22f37bf410a22a395c442bbcb4be27d0d02aa139eda873fc6c1e7a4467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3842da1429bdb1cd1cd8a620df78bb26610e7de6abf19281904b19c6b30c1d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libpthread-stubs"
    depends_on "libtirpc"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lxi.h>
      #include <stdio.h>

      int main() {
        return lxi_init();
      }
    EOS

    args = %W[-I#{include} -L#{lib} -llxi]
    args += %W[-L#{Formula["libtirpc"].opt_lib} -ltirpc] if OS.linux?

    system ENV.cc, "test.c", *args, "-o", "test"
    system "./test"
  end
end