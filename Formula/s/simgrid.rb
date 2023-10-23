class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/uploads/9bdf42319806680ee59c56210287ee1e/simgrid-3.34.tar.gz"
  sha256 "161f1c6c0ebb588c587aea6388114307bb31b3c6d5332fa3dc678151f1d0564d"
  license "LGPL-2.1-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "74b2b07b00f13d2474ce208225f4034666625ac6368ed56eeadb0081dc43c89b"
    sha256 arm64_ventura:  "0b0269eeaf15438edace7e743dc71c5c60c1a7be3f90fdddd276e5dfe5dac657"
    sha256 arm64_monterey: "518a8d49bd9b25052edb565fcdbacf6167b6db151e5ac79552bafee491deb939"
    sha256 sonoma:         "9bf664dd427cc2050b7f025dbd851aace8941e5a2199d41a639e766c70d3dedd"
    sha256 ventura:        "801431f43e08aaf16dc0af22d226e946da42c9f58f20b2798c6a7d9248bc343c"
    sha256 monterey:       "d7eeef3d0f67652493912896c36d406f2f659a391483cd65b4338958abdb7a04"
    sha256 x86_64_linux:   "304a802f1828e12afce2fe5c4839610162c08c8be6b0196efc8db6de26024329"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    # Avoid superenv shim references
    inreplace "src/smpi/smpicc.in", "@CMAKE_C_COMPILER@", DevelopmentTools.locate(ENV.cc)
    inreplace "src/smpi/smpicxx.in", "@CMAKE_CXX_COMPILER@", DevelopmentTools.locate(ENV.cxx)

    # Work around build error: ld: library not found for -lcgraph
    ENV.append "LDFLAGS", "-L#{Formula["graphviz"].opt_lib}"

    system "cmake", "-S", ".", "-B", "build",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    "-Denable_fortran=off",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/engine.h>

      int main(int argc, char* argv[]) {
        printf("%f", simgrid_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end