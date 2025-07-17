class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://ghfast.top/https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "d360ed1541fa4fc036132e7732fdf1e4569c187d3e4a4ddc07fd9dbfd121c4eb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d9587a436ad3dd4fba064a0ae281e0ffe55ccfb1111f8733ef26184426c97d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8875176f2be994785edfc4a1d67dfc1094880693927ac8ba76dca3c7f0f8159e"
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