class Bandicoot < Formula
  desc "C++ library for GPU accelerated linear algebra"
  homepage "https://coot.sourceforge.io/"
  url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/archive/3.0.0/bandicoot-code-3.0.0.tar.bz2"
  sha256 "55fd4f11c09fced2793b999a60ac32e160b53c136e6c3cb38b8170b13e7e24e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "538e15d13bdbf45d86740c87e9222d30da7b4cee2d80970d95295c7559271e57"
    sha256 cellar: :any,                 arm64_sequoia: "b58c4701b973f9e4cfcc0493616f5598647467ed55d5467032d242c87f6369fa"
    sha256 cellar: :any,                 arm64_sonoma:  "9d576025975585b8f0ccef90b287f8d15f36ff1d94bf36b48b6d81f9b41a4e43"
    sha256 cellar: :any,                 sonoma:        "6bd8aa505b25bb92341eb6ae90f09483c92ee99c0beee796a5a61dae9023cfa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80d995378cfa2c82cd105482159d93644da390fe1fe8eaf5d961949a073a6e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9347b0e9cfb94e3879bb4064a3db7a15dda73605fa00001f35691eb89b7797a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "clblast"
  depends_on "openblas"

  # Ensure CL components are present on Linux
  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Avoid including `cl_half.h`` on macOS
  # PR ref: https://gitlab.com/bandicoot-lib/bandicoot-code/-/merge_requests/182
  patch do
    url "https://gitlab.com/bandicoot-lib/bandicoot-code/-/commit/2c44303b510605f3210bfcb8d5e539408cb92c53.diff"
    sha256 "9c6fccd6bba9bd05c729ff4705f5a224ce633d2ba78dd19c5894187b05e45dc4"
  end

  def install
    args = ["-DFIND_CUDA=false"]
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