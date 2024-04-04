class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.2.2.tar.gz"
  sha256 "6cd905ac7fcf6293e34d7acaa9d5af901d85f182f82ec6ec3ee9f9273881791d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d8487f05703563a8801633d40bdc7322ea402b96a30a55a871ce3623eae8cb57"
    sha256 cellar: :any, arm64_ventura:  "70931ad7a7dd5159c947d426bddb54df7fda9816e5d51e5a6c5c4932120c8916"
    sha256 cellar: :any, arm64_monterey: "4a09619aa9f109827de4e8e2521bd03fac8401da64a0df96f6748c22b3a6d3a3"
    sha256 cellar: :any, sonoma:         "e8629a35045a78deb2d83a174cb98dd3fa2a96a94ace6d33fe3a8f07fc6877b8"
    sha256 cellar: :any, ventura:        "7257218b00701d7470643e9e5a7be74a5bc0b7011248ff708ed8fb97ad27cfc8"
    sha256 cellar: :any, monterey:       "f35a5fbbd3b44a8e6bb12c7a19a62de0f94b02a5394ce706ae9f39aeee34763d"
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