class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://ghfast.top/https://github.com/simdutf/simdutf/archive/refs/tags/v7.3.4.tar.gz"
  sha256 "c42ed66ceff7bc3e5f4981453864d1b7f656032843909b3807a632be46a1f5d4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4aa3fe8452dcf39781f905d67fb7abc70133f673a44e7f0a978e0eb4616596f"
    sha256 cellar: :any,                 arm64_sonoma:  "4bc92e9b8cc8f26be0fcbc9cbe36e685c18fd218a204b7ddfbfface1e49a79b4"
    sha256 cellar: :any,                 arm64_ventura: "857e3dedd30928846f569a5477b3707f9b053ae6ac1b879caf09313ac6575bb6"
    sha256 cellar: :any,                 sonoma:        "1d2e6e76eab989acd61b4065f2304317d6702047eacc2b67699ec729168631e0"
    sha256 cellar: :any,                 ventura:       "66b7b63cde90ddea298bbc402b2836db661b2b0274c4c6a5a838d7e901ce41fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "490fe806843fbe6bd6a894600d3bffcfb0bbe737fc1f69f0d7a07401523c3c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1098773e9b719568a2a6b2fa6a8b3d93d776615ba8b34ba86538013d2f5b1f89"
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