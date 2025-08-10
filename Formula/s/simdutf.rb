class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v7.3.5.tar.gz"
  sha256 "788a081b39a7dfb3755e02df07c67cdd45456b1d7d5b58bdf34b9764b9e1165b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "acaafaa3360f3bd0ce4d4f69b6a8aa23ecb86b12844870d3889963361d84e7cf"
    sha256 cellar: :any,                 arm64_sonoma:  "cf52bcc07e546c081b18fed2d981c6482eeb83b12419c5e664d5143da94f2c7b"
    sha256 cellar: :any,                 arm64_ventura: "b80356790cb43088a468ef112bae7e35ae050a9bff6dd44837f737bc099633ea"
    sha256 cellar: :any,                 sonoma:        "c789e3695e437a7c6645bd3b24ffb8ff0929e7155f18b6d8bf0703f2be6f6ba0"
    sha256 cellar: :any,                 ventura:       "b7a360c421f9827af98a3abcc6dda25163ec776e3bb6257811d8a4557b4a6860"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9159f9cfaa457cde9818e4fd67d8f95554b5ca84134d7bf69c8f0c72a6d4c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738bf317f9578881d4fcc724187e87610b424b2d5d3ad63b1ccbf8539811182c"
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