class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.1.2.tar.gz"
  sha256 "94f56bfdc4b46a06c0fa85112c491f4f56078a5e2182892a2d8694faf6714ee1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a4cb021a9720b9293288a4d203d31076bcaf33482f86d0aedc1e73cbcfe87cc8"
    sha256 cellar: :any, arm64_sonoma:  "d7dbe75119ac1c233b07f00d90a0730510d783d87c30320882a5efe25b4b30e2"
    sha256 cellar: :any, arm64_ventura: "9c29e497c07b6cc401d6474d6013a231c801eb7bd6f708061c3f5a138485a48f"
    sha256 cellar: :any, sonoma:        "1b8be1cde87547613cb6fbdaf24f66a8e2aa45fad26a1fbb218fdab8b0f3cbf2"
    sha256 cellar: :any, ventura:       "dd66e78af8c1d36133e6857eb99382659d2c06eb0b78f31e2e01d3e934c7cd86"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"

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