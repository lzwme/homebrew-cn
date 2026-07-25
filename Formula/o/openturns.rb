class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://ghfast.top/https://github.com/openturns/openturns/archive/refs/tags/v1.27.2.tar.gz"
  sha256 "0af43d5b7cada6fcfb98d97e7bb9e89aee5c98eaac7320bbef6f9404d9a84c8e"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "897cdfaf321ecdf0148d2febcf8f07472fa13b6d3f70b07f7ffe86051c72bca8"
    sha256 arm64_sequoia: "fbca9f594b827d5912f6995d0a27d8d154efbd8b4945f99613faa527a39fb102"
    sha256 arm64_sonoma:  "d5c245673dab2989fd6e8a61712b86036f51febfc861e3c89f229c66f01a8c2b"
    sha256 sonoma:        "aba55f3f555e7d2d91eb104f0631e5c57834ea24e068535dfc6423b3b777bb38"
    sha256 arm64_linux:   "3df93993d2086d4495aa763e1c9574b6e851dee2220d883d235f7016d673f39b"
    sha256 x86_64_linux:  "ea259ea710704e293d6e28a5b9aa91f9d4d9d9769d9f26edc141a2ef9a864240"
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