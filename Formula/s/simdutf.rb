class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.6.4.tar.gz"
  sha256 "86562dc31eda9681ecc4b7577a5c1f48e396e63f026674ef7b8d88752e634cf2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2b320441789540449f74c81f387245a15290dd6bc4084dc4798a19195e1b8420"
    sha256 cellar: :any, arm64_sonoma:  "261c6f140755c343762d5872ef976e971f5b7eaeec7aa04cdb7529a199f14e9b"
    sha256 cellar: :any, arm64_ventura: "7d3c2386bfd353ecbcf55f9fddc80e145d2d8000792d84b6e69f2ebcfda52b54"
    sha256 cellar: :any, sonoma:        "e35bba0dc6ebe0c852060d3eb566cfe300386dd8169755ddb9fdfa78f2395462"
    sha256 cellar: :any, ventura:       "0aa269da1d56a6ac24ada3d892430834422a4c7471a326ca3d5239a71a302559"
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