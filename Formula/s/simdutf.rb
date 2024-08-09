class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.3.tar.gz"
  sha256 "5074018bef577e560903ecf331726bd7909d9878ad710492b4c1626dcaebaf8d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1322499206aadd5e3dd3d36980a827b2d4f9c4dad1d2b3aafc416dc2569a1140"
    sha256 cellar: :any, arm64_ventura:  "dc2fea6fa4d885cd12b58b2c50de8059357a49b591c752d9267ad3c64ff95f2a"
    sha256 cellar: :any, arm64_monterey: "3edbfb26333200cfa0f799ae8d2427a388656f723ea8eaa9f7b50287820a5470"
    sha256 cellar: :any, sonoma:         "4b28722979d95b29a0b14888885350d3f5a544fbe55c0606c6d43a0af229aad2"
    sha256 cellar: :any, ventura:        "14a69782c6213dc8e1769548cc1f98c4236f7cbedad47d56f21089dc75ce6147"
    sha256 cellar: :any, monterey:       "278e124ad5386ae0b2231e11bf1d40d9cdddd29188b34df5e4efb8e2e2c80fa1"
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