class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:github.comsimdutfsimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv5.3.7.tar.gz"
  sha256 "731fb29c8c0b05c77b0a29dc37ab8eabe09533f000864a7c55e1ed2e1d33d1e7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f7a7f951c0435a491e3686978686eac32b1370a41d678adc3cde904ccd6f52bb"
    sha256 cellar: :any, arm64_ventura:  "b1c1abb09a58f4575db0b0acaf3636b5ec6c27037ba6f5f65b71fd2d662190d1"
    sha256 cellar: :any, arm64_monterey: "df6135380adbb1cbddbfd7d15dbe6d1bc2b1c54ce5b738fbd8ad88556f7c69e0"
    sha256 cellar: :any, sonoma:         "2857fe6bca17737945e3317b393b319e36cf1861bdd92bfe9971ffddb2a7b8ec"
    sha256 cellar: :any, ventura:        "a5e5c81c1d4a301e426b34609f14afde90198ed0c94f0854bf8cc6be5df2a529"
    sha256 cellar: :any, monterey:       "f5f45c435c017b8847b8b68201138d64a929d1a26e88e27a95326f1024c48106"
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