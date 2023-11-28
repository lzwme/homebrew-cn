class Simgrid < Formula
  include Language::Python::Shebang

  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gitlab.inria.fr/simgrid/simgrid/-/archive/v3.35/simgrid-v3.35.tar.bz2"
  sha256 "de4c34ea424d99702419736e51cb5ad425dc01502a39f303128483a70405c473"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    regex(/href=.*?simgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0d7e04a36480444650abf5d0b766c50e94304a66fd3026188ee84ca0f28db83d"
    sha256 arm64_ventura:  "e5b7d59b5edcd954b19453a9ef0afe07ef08810af6a041c26381acbbee9b619b"
    sha256 arm64_monterey: "da3663b588128a0c2f0a891e1820f3dc5a9bdddae2d62dc76a299a1fa7ddb956"
    sha256 sonoma:         "241eb81037a6200074c2912c4553b030bab62577a9a144683d8021a50c0a9fb5"
    sha256 ventura:        "b884f297125ca2bcb20e57c39336a3eb4c0e86cee54dc3c4ec38c8409bab93bd"
    sha256 monterey:       "ada9e26cffee590c1070288f3c719ee69a9910ace07f6bab9e11024ed66494b3"
    sha256 x86_64_linux:   "4805d5ddc4e2b49c90a3f00d7582d5057b5bff3144f89f5a7a2cee26721a82cd"
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