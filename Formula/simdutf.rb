class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v3.2.15.tar.gz"
  sha256 "c26d2e2e9124e1c20335d3880d74c8b0d74a5e247ba82ef82d15df4ccc413bcd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edb081c1a858389190e2e6197d60e5b9b712e937561b2a8f6c556e526a4fe0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add0e970d340523b8b279c716b142c75be9cb3af46acf9ca93f43b926c0667f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c327821db7dec5750936d59ba57f7bb08eff5ea90a793a4d72e9e799a8d0fcfd"
    sha256 cellar: :any_skip_relocation, ventura:        "e73799511a19ba862b27313670eeff742027a6ae206f8a4eb907290a9cf06453"
    sha256 cellar: :any_skip_relocation, monterey:       "2264442f75dd43a8f5d16f67db861abf6e3bc662d4ef64a0fc3d949f998049f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e716ecdb2ae729d7cc9b6aa1be02b1ae2d787a80cdad67ce420d4c96aadd655"
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