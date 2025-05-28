class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https:simdutf.github.iosimdutf"
  url "https:github.comsimdutfsimdutfarchiverefstagsv7.2.1.tar.gz"
  sha256 "5c2c0f8c752af8bc0f18d5eccdc78595c2c698aedd087beeee8aebd93dba6d1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsimdutfsimdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "141748e71b93c013fafdedbcf850c6dfb127d0cd7d6a0ec3dc9ca082e61350a6"
    sha256 cellar: :any,                 arm64_sonoma:  "ced5dbe6faf55a0697c3fe2912a57cb6e79cd6f2c9bd6f1b18e4c4c6de942538"
    sha256 cellar: :any,                 arm64_ventura: "3b11d6f13e3df8c2fca06ac4375a619514457470315da2be80d2e9ad3a929914"
    sha256 cellar: :any,                 sonoma:        "80cf6ef7005940675592e5cbdbb8110cbf5d27a3b16b758afbeb9308b476113e"
    sha256 cellar: :any,                 ventura:       "02641d1eee6a133fa196afda1208bc39ca9c5093f026d49231cfb47cb9c99d1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "966e8e0fa6e7d039666cdaa25aa5513891e1cfa7fea659220d3ae3cc18f3d657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1d8f81e42a7a6184e2382f87c6b56d867c3fedceff3ac8b686ce5251da2a7e9"
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