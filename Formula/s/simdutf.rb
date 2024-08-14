class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.6.tar.gz"
  sha256 "9daf83e7ad5c7ca3dca76b629424cbd61d33f8854d2906cff746a3de5152643b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a57356002adff378cb59f1bc36be9e050476a23893f967f34d12dfb656564190"
    sha256 cellar: :any, arm64_ventura:  "2254f7c6420b11397743057d773f02fa06a3965f97650323c95a37d4fddb6109"
    sha256 cellar: :any, arm64_monterey: "980458e2e9638e3e8b212dc6b5edfdf54d7f0fa6fd88557d8f52b169775e5ddb"
    sha256 cellar: :any, sonoma:         "63027467806229d0f65dcb8a4503b431bcded7d9867aad8a17fb948a8cb19c07"
    sha256 cellar: :any, ventura:        "f6585d8a5e341abdbd0f4161d238ea2fcd15ada399a15a99a55e00e5b44c6408"
    sha256 cellar: :any, monterey:       "856304396a486ecda40d5aefc214d4cf2c82ee0667f6cddf920d21594aebb7ae"
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