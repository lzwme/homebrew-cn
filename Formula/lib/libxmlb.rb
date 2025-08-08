class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://ghfast.top/https://github.com/hughsie/libxmlb/releases/download/0.3.23/libxmlb-0.3.23.tar.xz"
  sha256 "ab86eb2073592448a4e0263ab56e222de092c0a3964b66a8d696cac071c8ee3c"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5e5bd4c530987127a0545703f30eb73239fb8619748544e6f653dd1114c43aaa"
    sha256 cellar: :any, arm64_sonoma:  "b18b84f6e95ce698d15345503a6a985241a37155b47491524b8571e83e7a223e"
    sha256 cellar: :any, arm64_ventura: "c48e15d9fce7bd89d279734c08f09db016c7c81f0d8868c019fbe8777566ad72"
    sha256 cellar: :any, sonoma:        "4b1b3852e90646ca1691909e6e5cc8f19d524d56c59413db4486ca7c3c397afa"
    sha256 cellar: :any, ventura:       "3aed6ce6f11e925582d7da88876b58a1e90f22e0ab2fdfe2fd1c1be1cce3ba4a"
    sha256               arm64_linux:   "54d58500388918b029084fd675f326bee75fe9ca641c360c3bdb8ea8e9bc8ed4"
    sha256               x86_64_linux:  "517606dc98fd5522e38535b5213e58958bbb1fe5040c4e936b5b833ec3d8ca6d"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "src/generate-version-script.py"

    system "meson", "setup", "build", "-Dgtkdoc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"xb-tool", "-h"

    (testpath/"test.c").write <<~C
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs xmlb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end