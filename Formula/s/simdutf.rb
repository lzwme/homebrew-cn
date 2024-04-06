class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.2.3.tar.gz"
  sha256 "dfa55d85c3ee51e9b52e55c02701b16f83dcf1921e1075b67f99b1036df5adb8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "406a0c7ca8e2efffb89ca2a0cc9e75dc823dde87903e84a18d154cc3e17a789f"
    sha256 cellar: :any, arm64_ventura:  "e44c0849b12376da7786a6279b89a50e52b31500d4b8ff654a5206097dc64c1d"
    sha256 cellar: :any, arm64_monterey: "d2da2ddd420ce98c9068f6575d496ac8c605780d98a78a5c21a8e1279496af9f"
    sha256 cellar: :any, sonoma:         "18fe112bd671d3ebd7e07ef9072a0cc59c2b698fa6c653c3474c031eb671a6e6"
    sha256 cellar: :any, ventura:        "1d53f61251e2c659386fc5aa402797a315cf90f5a702ec736b188b8f5d85485f"
    sha256 cellar: :any, monterey:       "9f11c81d509a9d622286e8cd52d20f9d8095a2602a4068f7038d29643e6fa29b"
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