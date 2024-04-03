class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https:github.comlibbpflibbpf"
  url "https:github.comlibbpflibbpfarchiverefstagsv1.4.0.tar.gz"
  sha256 "4271dfd51f59d23c03d9ae62d8a92622af0f5216a620a7a666c4975c3c7cda6e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86471b49eea75130214830e14015385024aa7d3312f057c5f51c3016060ec720"
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include "bpflibbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system ".test"
  end
end