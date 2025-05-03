class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/2.1.0/bandicoot-code-2.1.0.tar.bz2"
  sha256 "177b703a8b7c9e6bac23cfb515ff9828efb136f118e23c9692b006a307c1b0d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38fb39f78347b61e868d852e5e3ffbca33ef16c1c14e74ab0cbeaa6629faf29a"
    sha256 cellar: :any,                 arm64_sonoma:  "59c1624e68eddc731153af13e1e48a8855d228ae2c1d83d2647cfea45fbe3145"
    sha256 cellar: :any,                 arm64_ventura: "cd54fd327ad3327d66e31f630db619ee4e16fb0bc82a644b95c3712a0a48b258"
    sha256 cellar: :any,                 sonoma:        "f45d45f72abf8eccd7e2d456556307566b13eedba8e1142b702d73c051de38fc"
    sha256 cellar: :any,                 ventura:       "a8dda1e9821f526287e84e2ca20a07583d4bc04880074fd95464430228ac10f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef4742a94ae9ca59c5a6bb1a1983a0c87557413062d304883536509f86612c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b987f42c5b3f57c05615932191f35dfd196da30918905fd848213e528cad9523"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "clblas"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    args = []
    # Enable the detection of OpenBLAS on macOS. Avoid specifying detection for linux
    args += ["-DALLOW_OPENBLAS_MACOS=ON", "-DALLOW_BLAS_LAPACK_MACOS=ON"] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end