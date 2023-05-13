class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.9.tar.gz"
  sha256 "55edc849b3e8dd4443399d647efab80e7f3a9a80719bb411027b33e7f8e9cb06"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "60fdd6b1d7531a08e6563c1fadb06b44afd0282cd9d2933e8dd0fca6d9e9e94d"
    sha256 cellar: :any, arm64_monterey: "3ef0ebf6ad59569bc42daa950ab17f440538b225301ab832de84b3371a9b0fda"
    sha256 cellar: :any, arm64_big_sur:  "1de3c9c5cd071dc8e39cb43f140d8c17451837be0a7053da6d22e2e4302d1999"
    sha256 cellar: :any, ventura:        "931b66433cfc6a0136b3c91e02d50dcf4e1dbdae8aa0d788b7a691bfe794053d"
    sha256 cellar: :any, monterey:       "2a96c6b3d59eae11d5cbd058a383554b037e7322832ec3b990799860b2f81078"
    sha256 cellar: :any, big_sur:        "9fff31dca61857ec784b70ba5fb4f580a0888be714e97c5bb10748a54095d96e"
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