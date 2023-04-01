class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "7dde5825c867d1ef41625b3126c4f7277cf16ff45630e7fecc24b7bfbec494ad"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ea89173762bc27b04213468e55165d6e1dd16e5c76711d319cef2523100253ce"
    sha256 cellar: :any, arm64_monterey: "4f89dd526f6e3543bc82d767e627f87e8ec07240079c2dc615755055962aaaaf"
    sha256 cellar: :any, arm64_big_sur:  "7f9e1abc105633b38a923f82e08569260331885d8d208537609134976093fdb3"
    sha256 cellar: :any, ventura:        "0e7f83a6e260ec54baa3b7a59475c0325eba0fe9a3a58038ff37d5860ed80378"
    sha256 cellar: :any, monterey:       "5dc122c65485be81c1958f990907bab856025c748b34bc0a329b94401608a969"
    sha256 cellar: :any, big_sur:        "9f60d79d40aa598f63ac016f4d3da996ac82dec6a0c4fb1dae1354b3495c2070"
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