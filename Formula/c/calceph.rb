class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-4.0.3.tar.gz"
  sha256 "91d2cc58ecaeab31c480cf21cd7f856bf6532b19e04a22ace4260d07d6813d44"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?calceph[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5b4daaee979d4bcd40b28a55dc19635d17b62d65715f989b6202a075863eb99"
    sha256 cellar: :any,                 arm64_sonoma:  "5784f2e2a2becf64f005c78357dbd7dc4e852225d12f2be5cc1aa11418f543f3"
    sha256 cellar: :any,                 arm64_ventura: "9c725901c63e0f630cc168694fa979a40ec8074fabac86ba23b5781d09c73857"
    sha256 cellar: :any,                 sonoma:        "6f466a59dd8cd7e48fa8c2a20ae5338c237986dc8059b74cbfdfe817d9f8122f"
    sha256 cellar: :any,                 ventura:       "89be04d4072953afd5ee5c3802aea58dcfdf25b1f0d036f720d9c6561fa2a267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88783834e6b0a64d64d9c38b2210af0db7259fd6fdd553a455664e07c0f8c7f4"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_FORTRAN=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"testcalceph.c").write <<~C
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    C
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end