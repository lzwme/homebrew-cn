class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.5.0.tar.gz"
  sha256 "47090a770b8eecf610ac4d1fafadde60bb7ba3c9d576d2a3a545aba989a3d749"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "585ed9611fca65bedfdb8515176913390a290b394f10d0829a545b14df268e6a"
    sha256 cellar: :any, arm64_ventura:  "c65475d47607e8dea2c68e0c3f2932340431e11cb18e1bfcddeb639b9d90ae9b"
    sha256 cellar: :any, arm64_monterey: "888a5c340d08ee42f5253f62f0d710d4684ff8a9124a6a1bb8deaa78e2a85f52"
    sha256 cellar: :any, sonoma:         "29fcd6954f014a2238c8b691fc9d5ad26be1ae0f66c7c7546aecafefc3900fa8"
    sha256 cellar: :any, ventura:        "89e5773dea8ba07568de5ec3732caf408c89bb0af9de5931bbd3c3a35c979372"
    sha256 cellar: :any, monterey:       "87100c5966e121734185c2b3d079c9eabf68c0978cb161dbbecc6b13bf61e1c2"
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