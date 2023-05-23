class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.11.tar.gz"
  sha256 "e7177c9cc0f88687473c7d57e6a10a6123277722716d7fbd627cb08f7cc76aa2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c0594d81464e1291f83d394fb8cfc2e25ab39da49ebe5fa93c45811140b7ee2d"
    sha256 cellar: :any, arm64_monterey: "0a50a8879cf5817f1c07bf3d771447158ec1f516a5a37a0403de373eec2b76f9"
    sha256 cellar: :any, arm64_big_sur:  "0f54253a00f2d4def2237349925cd1aeed3f0c53b4046a35aa25da6b1a92ee2b"
    sha256 cellar: :any, ventura:        "cf78cb1917caeb75d6182d237b1c2bc76e62e562661cdcf232822b0ec22a90c0"
    sha256 cellar: :any, monterey:       "884b1ef2ebea97ee05fc8a28d7488338da246b6974c99d4de1e93062fb52789e"
    sha256 cellar: :any, big_sur:        "f271e8061c6858ca0f2cf6fcc80b39510030579c1055d162303afd9432ea9af1"
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