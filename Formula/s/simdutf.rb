class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.7.0.tar.gz"
  sha256 "be104895a72c1e2326037310c76a6f0f494ce784834fb4ea8c92ac5b1a91c48a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1744024b3123389eaafb7fd6fddd05275a882f6f3c9302e6956ccb0fe3456cf2"
    sha256 cellar: :any, arm64_sonoma:  "c130bd13fd14770d1fc23170a04628ebc38f8558c1e7aa9d4d34731877b92b1e"
    sha256 cellar: :any, arm64_ventura: "c3411f5aa7da65098112032d7ebbab452801e4f002200aec61d43ec35e478bb4"
    sha256 cellar: :any, sonoma:        "fd5b0aa5a8b9b0e375848c5a5833386c3d7ef24c524bea5de96fef8a1d4bf61e"
    sha256 cellar: :any, ventura:       "2b01d99d1aea6f97e136478fea9a277d5ee029073b3372ec425273b56f8aa116"
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