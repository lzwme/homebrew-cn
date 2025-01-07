class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv6.0.0.tar.gz"
  sha256 "7e0cea800622353bfe34d693a7ac81ebfa9ba397ed2b8b5a79f367e83fa99a10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "607fae33d0d6acf7597bc831c7e6812ad8e4ac1962d6fa3701dce4ad6712b1ca"
    sha256 cellar: :any, arm64_sonoma:  "97a4b900dd97b7dde442567bc748db0bb4b8a90ca2200d13b7507ecf44dfada8"
    sha256 cellar: :any, arm64_ventura: "7c70fd0de8aafa9367da9d745351ed0b8c1e818db6db91f6cd31a840a9bdd753"
    sha256 cellar: :any, sonoma:        "f5ec6562d8e5d5837b7a0b692f5eae5e21afff40529fc3ce7297faf34a67c387"
    sha256 cellar: :any, ventura:       "cd89429d854a3ac505f208a50b0fe9ffbe2d5ae30a5d7925dff6131090a830b4"
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