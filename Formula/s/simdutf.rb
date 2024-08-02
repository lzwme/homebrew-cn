class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.1.tar.gz"
  sha256 "373e1e66a1c245817f0aa08ae8693b71d1703f9355d364e0d9d002929738ddcc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "dd49d7b383c3984258289bbb7e464b1d247ddd6f50369bd4802dbe5daa552e13"
    sha256 cellar: :any, arm64_ventura:  "9f837e8e461a46879d30a981793e4176568658c76ec672d07453275d70adad2d"
    sha256 cellar: :any, arm64_monterey: "58ca10fef6d8b0d109913027c0680cc490063d50d9aa2b86243ae47323b585d1"
    sha256 cellar: :any, sonoma:         "5fadc911f75aa898ffc84f981c6a8a2e7e2ceb6cbc4fd7113d21b71a740ccc3a"
    sha256 cellar: :any, ventura:        "07c626281b09ac96a74d9f16512a2dcb4ea473e6e1b54dba32aaba1ecfddc740"
    sha256 cellar: :any, monterey:       "11110ee5a3d3bebf169e1d3b91c65409719fee38c9b3e341f242e57490f49377"
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