class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.4.1.tar.gz"
  sha256 "584200fbfb7aeeefb760a30db72136fa715cdb6b40f9744cf3fee64d2fc4377f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "43fbc3840073ac6449d9ffc6063f7efef5ddaeee5066eaa7d0f0044ed80d9edf"
    sha256 cellar: :any, arm64_sonoma:  "e3e1cbad58f6a487b5fa4c9a6669e308b2e71b074dcc5fe8f81781902d73d7fd"
    sha256 cellar: :any, arm64_ventura: "af4625fb94798d3b09e9224be559e08ea119b65253860e742fc63aec8de08a27"
    sha256 cellar: :any, sonoma:        "0a52c9e7ec429b6e88c4f131a38a7e43134602203499f8043a8ea52d8fee7e82"
    sha256 cellar: :any, ventura:       "38b4d271a53c977c05d1d8a2d279a091589404e63f7a87de084911a4a61e902d"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

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