class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://ghfast.top/https://github.com/openturns/openturns/archive/refs/tags/v1.27.3.tar.gz"
  sha256 "6cd10e65682a09a5c8f7b40e3b4926d64fc93dcdff19c0e432ec843886cc1bc2"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "aaa16e0b8d9da6cef2358dba2a4fd34922cef041fd35a7e8c34241571bb0315b"
    sha256 arm64_sequoia: "06934d525285f51512c94932c946eded4e0fac890a0bff46b42d41d53ee6d85d"
    sha256 arm64_sonoma:  "a6156e3e65bf9ae1e0a727875030291c11e809e9d971c8ab02a7af5160acc40c"
    sha256 sonoma:        "92854218f776b545973a02f52690f5915ed418966c35536e478925dca7284445"
    sha256 arm64_linux:   "4eebeb920de7da4b555b960d4e8f07ac1fe3f60b4cde3c8edc2174b4fc9fd9b7"
    sha256 x86_64_linux:  "385da5290a0c8e5557d4f5f982d509b3c2ad0bfa912438495dd3868e95d4ad98"
  end

  depends_on "cmake" => :build
  depends_on "nanoflann" => :build
  depends_on "spectra" => :build

  depends_on "boost"
  depends_on "cminpack"
  depends_on "gmp"
  depends_on "hdf5"
  depends_on "highs"
  depends_on "ipopt"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "nlopt"
  depends_on "pagmo"
  depends_on "primesieve"
  depends_on "tbb"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %w[
      -DBUILD_PYTHON=OFF
      -DCMAKE_UNITY_BUILD=ON
      -DCMAKE_UNITY_BUILD_BATCH_SIZE=32
    ]

    args << "-DBLA_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <openturns/OT.hxx>
      #include <iostream>
      int main() {
        OT::Normal distribution(0.0, 1.0);
        std::cout << distribution.getMean()[0] << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lOT", "-o", "test"
    assert_equal "0", shell_output("./test").strip
  end
end