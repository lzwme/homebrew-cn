class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.13.tar.gz"
  sha256 "978ce70918cd70a33fa5ec9f6d362b4ff29fc470e6efe5d80511af736e9f28dc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a22f7b7e682614b69660db9aacc3aa75749b5f53fff40dd553d0a6ef337cfab3"
    sha256 cellar: :any, arm64_monterey: "fb37ba05a20efad08d3056a4aaa863c3f4b42355478f519cdd9d1888ef66c068"
    sha256 cellar: :any, arm64_big_sur:  "d20b8e6754ff4ebd81d1a726df90f185f78bbbd5264b454d90431bf36688f00c"
    sha256 cellar: :any, ventura:        "5415d557f3d9995aff142fead5d07c74327c50ee77555cefd1818a701f21ac4c"
    sha256 cellar: :any, monterey:       "cb5f245e487e02c02590175197d880f9310abd3122a2eed7265dc280f3aa3077"
    sha256 cellar: :any, big_sur:        "bc0ec18c6c89ee8bc51882fc15e381614b9a22c3482b7eedc4caa6ea10cdb2cb"
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