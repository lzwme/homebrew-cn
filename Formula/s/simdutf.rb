class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.10.tar.gz"
  sha256 "a8b3b2de3e3425cab1d5d3e3ffb50184b95a9cbde5be449f5907875e31699aa9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "430b5b121c01f52546ad50277d22943c31894065dd3048103ba0f44ff563f8ca"
    sha256 cellar: :any, arm64_ventura:  "5b484619346bf5d28d7851105e63b5388ca611b4f99ec17060c4ec7d09d79ee0"
    sha256 cellar: :any, arm64_monterey: "2a7b1c7a3c296bba199ba1dd8a9075d89b6b76b2fa416267cbdfe01203c4daee"
    sha256 cellar: :any, sonoma:         "de73680f9e692722713d0fc150be3faebc5b5a4504e5e9fa6ed6a5af324abe0a"
    sha256 cellar: :any, ventura:        "abb1e8f734c64b5fa6adee611b3432b49a1c405ac87a89c08c1f732575379d07"
    sha256 cellar: :any, monterey:       "7d9c2ffdb112c1560616450a953811c2370f0866d4c35b800c9727cf301af5ae"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https:raw.githubusercontent.comsimdutfsimdutfv$VERSIONbenchmarksbase64CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https:github.comaklompbase64archiverefstagsv0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "buildbenchmarksbenchmark" => "sutf-benchmark"
  end

  test do
    system bin"sutf-benchmark", "--random-utf8", "1024", "-I", "20"
  end
end