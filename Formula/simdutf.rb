class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.16.tar.gz"
  sha256 "7a8f789d400fe6a2fd8ecd430de2e27b4b9117f9dd2279bec85e024d5f302706"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89ce6bf62b014e58304ebcc6c7d18df8dc0f6cf81f9773f909af9dee9f744da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d686afa07cb5befa09d22c31943752072526201fed8008cca9d484ac1f890455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b91ec1dcb118e6becdd8a43fa7240e3c3c2c6be0745184dfc9114df0acaafd7d"
    sha256 cellar: :any_skip_relocation, ventura:        "eb8df0bc003841bc87ec23c0937c9fa558f86c4a5a679201fcde288ab69e346f"
    sha256 cellar: :any_skip_relocation, monterey:       "53ee3738da098e70243ad71948c55f94ee39351e8daccda55e92ecb6d4ee976c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b31489f05ff5758a560fdf7d9a15acf77d8ebf44ec463d8e155cc3fac3637ed4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end