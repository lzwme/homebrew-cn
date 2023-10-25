class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "e193c4b5912612147c266ea7ebe2108099f3bcab5f0dc34e6289b2a47495ae2f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d52b28bc17911bb4524dabd9c333688a69f9f94dc120701de2c2830757e16ef4"
    sha256 cellar: :any, arm64_ventura:  "47fdcf2bb6fe238ceec71f9df314f255a22528b59780dec36b1a16e489989332"
    sha256 cellar: :any, arm64_monterey: "dc572602c89c96b9a3b54469ad3c0048c21188da4fa7cb2be66bda1fe6966ca6"
    sha256 cellar: :any, sonoma:         "ef20ecc0050886743a571b264e1ad0f1beed4ba1fc77755273bdba2930cbce35"
    sha256 cellar: :any, ventura:        "8993f663e1b6ee9407c4b38fbba2b2bc3b3bb2b61d7a973f9a922402d4ebadd7"
    sha256 cellar: :any, monterey:       "5ccf97e065410432d597cdb7a2ef2d7ed5947a6aaef8ffa29afd6e6f092bc310"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  def install
    args = %w[
      -DSIMDUTF_BENCHMARKS=ON
      -DBUILD_TESTING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end