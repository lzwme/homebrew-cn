class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.11.tar.gz"
  sha256 "7926ae62d903a27452997e85d60c5dc04667d7a5ff44c2086ae90cf32bc4bc2c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2129201da806c89c5b618411af8ac2963ac02f3148fc54a4ac98018e72785ca3"
    sha256 cellar: :any, arm64_ventura:  "842916858704c7efded77a663dad37fca7ceb96faf6d3231fbb70cbfcba65707"
    sha256 cellar: :any, arm64_monterey: "b9d0469763f1c0f672176b3c1ac308efda21ed37c64d72723eeaf49d5b20e06b"
    sha256 cellar: :any, sonoma:         "7c4165b256d7be2d0400e0099e2371c0e81a84d6fc209a60d6d2f4549d0d4b01"
    sha256 cellar: :any, ventura:        "fba827e4b30d9e0cc60b1413f7438a6b660c261780bffaf22532a7d67bd02d0c"
    sha256 cellar: :any, monterey:       "2478bc76c9786ebb3650f9f992340e3977c5599baa0067274268dccfa9c2dd2f"
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