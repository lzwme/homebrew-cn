class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 30

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ddb21006c0e861a027456d9011a38f68c491293f80d23a6dc905faa3f2e0e4b7"
    sha256 cellar: :any,                 arm64_sonoma:  "b93d99e35c369cb856138e780d1f9aed0525d49431224f538fc84c8b46b1dff8"
    sha256 cellar: :any,                 arm64_ventura: "0a0b15276af1e0b7c15ec0b1972d1af753390058b28c2d719b3b9ad2838a7b89"
    sha256 cellar: :any,                 sonoma:        "ba9ffaab5f896984c2d8507203f4b5786e1d3f7e403b0873d5867cbffc6d9289"
    sha256 cellar: :any,                 ventura:       "5d0b745d15eda4ef7f5e70645eb9df729378a74c18a59dec50e7380dc83ade3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af245e2db2f9d27e4c412d794edac1757cd1d6c7d5f71b9b45d058b559a3e92c"
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