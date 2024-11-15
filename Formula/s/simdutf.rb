class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.6.2.tar.gz"
  sha256 "325c012e7c29e549779cebfe5a43a3197d9d675b6764f6de547ef19905b56b76"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "57f88db5377a15eb1b7f622bdc3f9abfe4b64cc1d895ee45a01810225b4431c9"
    sha256 cellar: :any, arm64_sonoma:  "7b5cea1f885bfc808eb55f6af84ffdf45a037ea772325df7f90050d08a17785f"
    sha256 cellar: :any, arm64_ventura: "a749a83de2c936e949385ba373f317bb4106b9648e5c0b53badf9679b5f933fd"
    sha256 cellar: :any, sonoma:        "79b5d880ff104c7491f9c1ce412c2f916292da264f8bb1c0ff78956333508233"
    sha256 cellar: :any, ventura:       "44ee9d1836bf80171b4d1be6f02643d73b201b41e57e1ddfcbebe7b6fca21d68"
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