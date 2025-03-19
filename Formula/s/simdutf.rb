class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.4.0.tar.gz"
  sha256 "96c89f9d49b74e4bc7e6dec6c7a7d343dc078cca1ea0ae3e5b499ac1958024c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f9be77881286087611d29679169212b76feeb18217126c67827c9e4a0b3e99c9"
    sha256 cellar: :any, arm64_sonoma:  "33f41be164409624b7f0097c5f66d2e46d5c41ff1aebc29e80f6780cb0e935a3"
    sha256 cellar: :any, arm64_ventura: "a01115295def6d5eb047b5d00aef2f8bc809b59a216048a2b6812cbd5c558e64"
    sha256 cellar: :any, sonoma:        "9cb569f83641e1338575f56247bf027e04294914a578f23124e9f2bb05c88609"
    sha256 cellar: :any, ventura:       "b5a1a94e9e766e8aa19cc38e0ed03ca9a26e25400d1b3629477f1a5fa59a25f6"
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