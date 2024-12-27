class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.7.2.tar.gz"
  sha256 "6884f4978cf8a0bab0c39e86d9b6e6057dca41a1d591ca2623fb87f9d5dc83bf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6882b76b61d5596e8767ea348f2fad00a13c27efd86112f0ff82c3f3e60b7081"
    sha256 cellar: :any, arm64_sonoma:  "709090bf106ec3a46ff616be9fc29563a5c2092c132a3ff7a50502145d972561"
    sha256 cellar: :any, arm64_ventura: "f239f47aee7517aedd6771b19749f00bd09fe0ec8440b1f689afdc0afc4b231b"
    sha256 cellar: :any, sonoma:        "f8730c57a8da09c4a39a266868f5560235b28f82fa933308882e49b6d0ac692f"
    sha256 cellar: :any, ventura:       "7c14d0179aba7f12cf6981808d4d86f805f733b21245d99f157013a80fbfcbd0"
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