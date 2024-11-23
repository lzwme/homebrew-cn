class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.6.3.tar.gz"
  sha256 "503070ddf27e26c051b9500dfc7354ec8850e11076f47db32635931c85b630c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6ad935b6baf56a640e4b71b5e33e4f3cf88aeed80142a04d60e5e01fdbc37cf9"
    sha256 cellar: :any, arm64_sonoma:  "0b23e4cdc44e3f2e2ff957534e80d34c5f3e36e3bb9314a604f69dd6c5d289da"
    sha256 cellar: :any, arm64_ventura: "a68aeb8f1fd6248d6c6e5a2c16c895c8a2d3d9a0af166ac4c068530a6454c8b1"
    sha256 cellar: :any, sonoma:        "d9c15febe12fe9289e8d117803421f6b2fdda66c16cca3b84686a0efa726f17d"
    sha256 cellar: :any, ventura:       "4bcfa45952f7d18a0c52eb5f58de3b872bc7ddf2921438c29d19a64368edeb80"
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