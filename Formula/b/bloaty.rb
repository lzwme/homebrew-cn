class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 33

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8ef7e9087916bd4a7cdb68ba7d95787de0a9244e890e70bc0aad3a32a91b797"
    sha256 cellar: :any,                 arm64_sonoma:  "475ba8ff46148c2c4312409aaf84a0924b11ce4e6687fd87aa7c6a2d09fa0685"
    sha256 cellar: :any,                 arm64_ventura: "792a943b4df100473f7a88dda7ff4090f04cfc488bef0cffc1489565f1bd514a"
    sha256 cellar: :any,                 sonoma:        "bf6d49774d3eed00d1c9de35a81a06620f9285e4d646808c3d64dfe1d3a49972"
    sha256 cellar: :any,                 ventura:       "ae515060168848b97dbac7426ddeeb9cfd3d798770809baa76bfe41bb3b9974c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6553b28f758e775409ac83f8670c89186f10855c794b510e520efffeff79a2c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath"third_party"dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL,
                 shell_output("#{bin}bloaty #{bin}bloaty").lines.last)
  end
end