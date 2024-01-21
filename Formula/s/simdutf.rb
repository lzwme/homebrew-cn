class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv4.0.8.tar.gz"
  sha256 "bbc1b5fdfec7d0f83c6a9d24bf90d10c2a462f30aa1ced30bed72288006a2194"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0ba2e926974fb2f8c777ac539864405f5be3c1314b67edda7a6fa80e170161d9"
    sha256 cellar: :any, arm64_ventura:  "37ad8ecf08a0f54d7747bed875173fa62d5663b67784c1874d55f8df0da0a9e7"
    sha256 cellar: :any, arm64_monterey: "6284e4708b5bfae89b91bd92baf22e247f4c7bdf58a9353de81945f457be9937"
    sha256 cellar: :any, sonoma:         "bea00c9259369edeab19b03f2b6abc83299cf14590909fd869cabfe43a8fe437"
    sha256 cellar: :any, ventura:        "0fdb9c9bc2b24fe916fbbd863e118c28992e2dd2e5ce33a9be856dc0bf4e76a9"
    sha256 cellar: :any, monterey:       "690d3a176378c3de805a98cf017fdc335969c37219ff3f78b483e9c7d6cecce6"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
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