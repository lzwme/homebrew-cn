class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://github.com/simdutf/simdutf"
  url "https://ghproxy.com/https://github.com/simdutf/simdutf/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "8e78866e2a3a77e6a6cd5a27a6896d5cde46a4609c10a562d8487d6b4c1dcf8b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c429d410be11bf5d4eecc8604843cf7435f64363c69164b52f725e2e34dde466"
    sha256 cellar: :any, arm64_ventura:  "5e171791519538e30e060ec098d23b27c7fce71ceb868b524e92144ec2940089"
    sha256 cellar: :any, arm64_monterey: "b751bca90566354d805cd2979ae80800235b9c5f5320e90f18c701339fc707dc"
    sha256 cellar: :any, sonoma:         "7442bd55fa5f87f9f85590cc42bcebce82206ac226f6c4411931c5630ca9d5b5"
    sha256 cellar: :any, ventura:        "697c4c0d4c37d6b38033c86033acffe1d20cd544c8292c3bf367c9fcbe5d22ab"
    sha256 cellar: :any, monterey:       "f495c5f46a815ccc1756f87b750a1cfc819328d3ea76ea17b68f055e44c89fa8"
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