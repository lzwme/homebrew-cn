class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.09.00proxygen-v2024.09.09.00.tar.gz"
  sha256 "825c0724844bde42e226cd65513fee2e8f8f88f5e233914de1d5b4837aa59505"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "393e8060390eeb79b9fd50692616d6938be4cee39cf7a805b8f5117144f8d3c1"
    sha256 cellar: :any,                 arm64_sonoma:   "18e55cbe2dffc24a0ba5d15479e595f5b36e363f00d149644b0726ba0706a55c"
    sha256 cellar: :any,                 arm64_ventura:  "c2fed3990c340e5ba7a6c397e1b99cdfd03a1abbe31dbeb87c72ca6b80a5ba60"
    sha256 cellar: :any,                 arm64_monterey: "4ce2705f846f96b8f0cee448569210904064b4c8469078e2bc97f02af366ca8b"
    sha256 cellar: :any,                 sonoma:         "c874efff2ba6b5993c7b1db3162fcacf8431704db8452b5c2223f5a8254f34b2"
    sha256 cellar: :any,                 ventura:        "108075f238622b35da95ceeed777f43aac08f1f9438129f4cf1eb47ad26d733e"
    sha256 cellar: :any,                 monterey:       "6320fa1dd511c5d5dd6ed58c556aa74163919057eb4fe544378872b440c052d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3063a4e744cb7389e67d6885ba9b46f4fe6695844c19296f4f720ac9b0e86a6b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    pid = spawn(bin"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end