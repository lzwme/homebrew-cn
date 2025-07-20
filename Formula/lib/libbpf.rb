class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://ghfast.top/https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "f6fa65c86f20d6d2d5d958f8bb8203a580a1c7496173714582300b724e37e338"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "902fa223a0d581874f5d2fec29040ae9b525936e1e20b5476e7223a332579425"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "811c6f41ef6a038c4439e82cb89a4e081d57d2d20de3be2ad13249130ec92de9"
  end

  depends_on "pkgconf" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "bpf/libbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system "./test"
  end
end