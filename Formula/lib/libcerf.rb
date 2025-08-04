class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v3.1/libcerf-v3.1.tar.gz"
  sha256 "4c07e2a8e2b4d0e4d48db9e0fc9191b43a0e120e577d55d87e26dee8745c6fab"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git", branch: "master"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ed1e01255af3afd757e542f915e5c4853cc80be70e3c3c0fd162bcee86552d3"
    sha256 cellar: :any,                 arm64_sonoma:  "372aa9aea34188e7f9a13962d71f007c9a19a88869fb5d0f93fe1c241e7da914"
    sha256 cellar: :any,                 arm64_ventura: "b2395eb9c5291d54889ea73a5f8392439072b87702f6e3bb12fab84470a7e750"
    sha256 cellar: :any,                 sonoma:        "496c798199e82753520cfea6428e404c129f2d2d44274f6be7003ae4ccd1c120"
    sha256 cellar: :any,                 ventura:       "732a3b79cefe80477a4ee4f1628d91348ce00b3cc6c838e8913aaf88b299381b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "665d5dc1a5b5e3f1b50a12b05dacc78bd31921f5a6806146a8742eea51965a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89283a20f62d6088094a98c10b68aef2e61f5300ac583485f47a85645ba8f2df"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end