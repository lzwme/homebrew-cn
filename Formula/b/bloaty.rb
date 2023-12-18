class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 20

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ef161dd9f7fa9dd39b78ca6cef73a219b709e25df186c55a9d74634f8708e90"
    sha256 cellar: :any,                 arm64_ventura:  "213f2a3d7cd026a0d801f6f9d02ccd5eb955db99573c31859c6f66e8686d841d"
    sha256 cellar: :any,                 arm64_monterey: "4c97d28a960b88cc818a756b897aae0464fcaaaa5a92200bd224c2c9dd8152c5"
    sha256 cellar: :any,                 sonoma:         "517602112123c95a377e6eee10e9132d15c9faa1542e84fed8f3cbd8ab23cf72"
    sha256 cellar: :any,                 ventura:        "5d0ace65a2d09a3e63a6138d083c5a4c3c6a69e8f42e157886370db9411c238a"
    sha256 cellar: :any,                 monterey:       "4b040c2e520df5f44188d460d66d8a00122630bf26902235aed401955f8b616e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0076815ba2b562d0d60a6f634c46c780cc8d3123eb8c70b41d6352b5c9528520"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https:github.comgooglebloatypull347
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches86c6fb2837e5b96e073e1ee5a51172131d2612d9bloatysystem-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https:github.comprotocolbuffersprotobufissues9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath"third_party"dir).rmtree }
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL,
                 shell_output("#{bin}bloaty #{bin}bloaty").lines.last)
  end
end