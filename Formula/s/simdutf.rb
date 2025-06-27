class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv7.3.2.tar.gz"
  sha256 "ff5ee7fa9a02372819ca9fbb78983dd6e9a2140a13507c98fd9b91d2766bf9b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc43932d1b95f2da91e670b168b024cc9009d234f5ca7981a215299594efab41"
    sha256 cellar: :any,                 arm64_sonoma:  "db4bc4c8078f77a92bac528c37fd19621b88b93b31f4b7cd611d016fbc0fad6b"
    sha256 cellar: :any,                 arm64_ventura: "8f015e41ee3b084b0a075fcf73616addd7d17000873dff5067bc390f5c9ba885"
    sha256 cellar: :any,                 sonoma:        "53af3db591207ee420f4f7f8140cca65f4ea4cc59182209f4a5e04ff2585aab5"
    sha256 cellar: :any,                 ventura:       "1d04ae8f5f40a0fd6ab5f8da9fdab9199991e3faf307e2b3d10d21d207e3a201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d1a369d4c0e31ad638efcff085a07be71b7588464f4247330433a1c34b2e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a024e6299de78ecd40b4d7e47a178bfa35f6de6267ef12ea2c204d66aa06cf"
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
    system bin"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end