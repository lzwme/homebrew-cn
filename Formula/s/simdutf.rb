class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv7.2.0.tar.gz"
  sha256 "8fba8dfb1eea6aca2cc73b3fb3c6b98a9b2397de84d09f0b5b3e931f05bec294"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1688548ae84ae3d9e4c21123bfa9715def13f8644ba1cd5e93defa6d003b4cb"
    sha256 cellar: :any,                 arm64_sonoma:  "339187a73d4f0633a29aa7def362aa4d0df0671104c66619d2d9cf9a9aac1cc7"
    sha256 cellar: :any,                 arm64_ventura: "a5a44856dd590f4dc60bb915c2efa6db72e57cef88f161942d68be1202356535"
    sha256 cellar: :any,                 sonoma:        "314e5ec527ce0bba24e6d04f7f43a46a93649e3fc16ad7b35030a5ecb7fc6113"
    sha256 cellar: :any,                 ventura:       "56a58aa55c6ca2010ffa5bf07b3f7761f01b4a2337daac9d573864ed5118c921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8376e8656da8e1177d3bc637412d8e5e5265288cb0e0d7e8ae628c584c51565b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c132bbe52f63c712095f938d9fef9f0c6addcd8ce7d2957f5131ce2cb8930d"
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