class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 32

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ea6ad2a18c50a8381daed6520b7be110bc20d4aa8f909fc25377340175dcf21"
    sha256 cellar: :any,                 arm64_sonoma:  "addd1d7c03488ff0d18ec6cc8891c5151e5bb2b95228bdc4277c4a6d25a30ba5"
    sha256 cellar: :any,                 arm64_ventura: "b1f3207318f2156b8caf626d9f5d59560d9701c28e75ae40387b724efc13aa9a"
    sha256 cellar: :any,                 sonoma:        "0940470ec3c169c3e5c3cd886fa779c19e64341f06632c9443f2e3e5741e3195"
    sha256 cellar: :any,                 ventura:       "199ffb69cbc6a2cd3620526bf23ce7f4da2199a0db6fe6d3b647aa993864d049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0512f5da7f9ebc11a451c84baaf572aae09a3190bc077ed18c02e943b6782ab8"
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