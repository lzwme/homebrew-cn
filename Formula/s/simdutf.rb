class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "00429eca296f00d9b93939d2561538bad601602ad02fd01ba9ad366268773751"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3c22ffa82a763b273bf5705f081ff0e7203ca1f16f2fde2e40e7aa60fb7ea725"
    sha256 cellar: :any, arm64_ventura:  "a7e7bb0c9d88f42066a57010d8558a6ba5b12cc93eb4fb0d003d2583cede1024"
    sha256 cellar: :any, arm64_monterey: "36355992b8dd5bc2c846fd2c72f8d4b269c1114675cdc45061fe39cf7adfa68a"
    sha256 cellar: :any, sonoma:         "733f72dcc09e7d478895686cbfef706f798d82cfa96b5f0b535dc8d4af1fc42d"
    sha256 cellar: :any, ventura:        "314e753aa7fc134f7321da0fcbf958465bd998eecf53c3be36241c6bae809331"
    sha256 cellar: :any, monterey:       "5150628a108f7b99a8fe5e3fdf4a6d3a017218f7ba6ce5b717ab4c5a9b4c560f"
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