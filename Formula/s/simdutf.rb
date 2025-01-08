class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.0.2.tar.gz"
  sha256 "2d31db5794fe1d508e0104f32e65dad5570cf7ee280d3ecd09bb4ed8a4e4579c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5c7135158d5cd772def886516f1944cdaf86e5ae47afd6113b3c5a80173600c9"
    sha256 cellar: :any, arm64_sonoma:  "c68247ed533bff79669a4014604c5e8536cdea0337676b439384a27436270f00"
    sha256 cellar: :any, arm64_ventura: "23b01fad7939f4e14dff1b0902b6352e5d443365b279b0779d07e68d2f18efff"
    sha256 cellar: :any, sonoma:        "604109c4a19e4fc1682144dcf859058aebd93943265c0c3e76024ac03256d4f7"
    sha256 cellar: :any, ventura:       "c3602ddcf4cb1f5dd1e29c7f63ca1a8d4447fd0aae9c806669d5f4d547a64001"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@76"
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