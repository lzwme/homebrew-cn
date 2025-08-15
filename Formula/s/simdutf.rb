class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v7.3.6.tar.gz"
  sha256 "c08f3dce1cbb7a8bead9eb53bcbda778e8a1c69b7d3a0690682f1b09fbb85c31"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50523672c8aaa4b91a69f68e27cd77483063d4d7fc826a8ac5b6aab5311e8b9e"
    sha256 cellar: :any,                 arm64_sonoma:  "6233d1f03487dae0eed9850a724973feb09703bd5a93caa526d0b08c8943bf5d"
    sha256 cellar: :any,                 arm64_ventura: "102e5d3344120c146b4ef4a0a16a945ca00ae9277f1fb55dfcce4524014dc22b"
    sha256 cellar: :any,                 sonoma:        "3456681917a008f1093e97d6686cc927b68c743dd03764df6833e93bf5dded04"
    sha256 cellar: :any,                 ventura:       "923b12f56225be55b4c92a80ee6ef66fa72164f823fb357712928fb3fd848e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a36e12aa767aaa509f467b5cdefbdd3d613d7b14d83cadc5a654d2e46a07c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3899839ea7465d3b2535a24e1ab51c823290c08c03a8b5e31646e4ee96a9fbbd"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://ghfast.top/https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https://ghfast.top/https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end