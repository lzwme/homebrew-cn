class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/1.16.0/bandicoot-code-1.16.0.tar.bz2"
  sha256 "d3049c8caed7ea527565bf96030d190282d0d9cf5f2a33b5a2dd393a60f01e8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe872e9c9d278c330ab54f9645ef503189f938176a943198d93cc866cc499a14"
    sha256 cellar: :any,                 arm64_sonoma:  "672ec9569c42fd5d97be9fc81c9721c0eb3c016b632badbfb38176a8de97afd3"
    sha256 cellar: :any,                 arm64_ventura: "eda4ccd849b8aa82a14e9eb520512ae55dbac19f98f868b9cc9dc4ac392d6e37"
    sha256 cellar: :any,                 sonoma:        "deeddc134d35ee37dabc3daa8ae6c544f3c152ad16ffa3af00cd09b437efca24"
    sha256 cellar: :any,                 ventura:       "3fb92dd99616ec54cca47bae78706daa6a6bdb529c0978506d95d6a1a3534744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3faa04cbe15d7ec9a39a2e120268ea06413d17d6154ec5894c0fbe9e646565"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "clblas"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    if OS.mac?
      # Enable the detection of OpenBLAS on macOS
      system "cmake", "-S", ".", "-B", "build",
                      "-DALLOW_OPENBLAS_MACOS=ON",
                      "-DALLOW_BLAS_LAPACK_MACOS=ON",
                      *std_cmake_args
    else
      # Avoid specifying detection for linux
      system "cmake", "-S", ".", "-B", "build",
                      *std_cmake_args
    end
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Create a test script that compiles a program
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <bandicoot>

      int main(int argc, char** argv) {
        std::cout << coot::coot_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lbandicoot", "-o", "test"

    # Check that the coot version matches with the formula version
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end