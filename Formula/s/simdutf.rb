class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.5.tar.gz"
  sha256 "e6706d7fc68f6e1541414dcf45abe6190d591505d08bff3cc53f55642568f28d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a03414936246f88adf9b18a06a6b7f83cd621dc55c19e3ee73031b1a3a39f091"
    sha256 cellar: :any, arm64_ventura:  "924da5eacf67458cf09981bc7d471d56b718dca2868b04bd4b67c82e8bf738c0"
    sha256 cellar: :any, arm64_monterey: "0f287b47fcf8cedceb002207b56fd22944103b7eebca1dc9b59deeab58e74510"
    sha256 cellar: :any, sonoma:         "4eddb11999908a980e39f34c0f971e923c8d5ba59e82f2f88e03bcb0fc1c95af"
    sha256 cellar: :any, ventura:        "deff99339f04153d78abae6a331ec5161178d9f9aebb042af9d7282d569238d9"
    sha256 cellar: :any, monterey:       "fcfad42c244c36b68be4bbd654924e75c4c8a8bdf4eaaa5c0de3aa4b5408d6ba"
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