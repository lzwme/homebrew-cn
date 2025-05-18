class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv7.1.0.tar.gz"
  sha256 "485ad50fba42e795c6b0fd2541ed3fe244ba2dfebbb134dd3e50e32e6b9c63cd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c5f278f07a39e80099c6fe3aa8a66f57993084e0ca20664891fad20b9f3bf9c"
    sha256 cellar: :any,                 arm64_sonoma:  "dc0d605b0b517ee7d906b54e05902dda5fd2f3c0829a79f75be90c2ca6876454"
    sha256 cellar: :any,                 arm64_ventura: "67e67774bb82c26e3c41459aae70dfef2a98ae0895d857121ca247b7fa19af5e"
    sha256 cellar: :any,                 sonoma:        "192ecb8220de28e463c98a5875bdb62eb5f372b4d450ed93044f69fab50c65a1"
    sha256 cellar: :any,                 ventura:       "0f3b2670b5e088f3b9a8453f7ac3ec95f6bc8cf6389150740bd0483a4d1d2170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f8420450a79e46b7d6b2c44a744266ba741ba6d0cd81af45e74c3f101d992b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a9bddb6651ded7b6a744f3f7b307f951005b228e29918442896cd347a324b1"
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