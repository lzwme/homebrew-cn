class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 25

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "88dfb2a5927ced0f2553404d504dc1e1f935f4703f4f3f73abb750791df2d4a4"
    sha256 cellar: :any, arm64_ventura:  "118772892205cb60aeab6f9dcf81f515882591fdbc0b4156f9cb80d17febe4e5"
    sha256 cellar: :any, arm64_monterey: "bc999c1bebef7ea6923410a25dfd1b17f876569858dfd57d78be03c8e0b83ecc"
    sha256 cellar: :any, sonoma:         "1052daf64656f9081fbe9b2df7dcf6ae656b7a0a7c644b2fdf2479aecd9757ff"
    sha256 cellar: :any, ventura:        "4a7206c0d026f28fea563b7d66790b2efef7a426b461d9aab0b1cbdf5bc34ea2"
    sha256 cellar: :any, monterey:       "8f055baf636099c05d3f76af373ac19b8b965dc4740746566272b6581c8e29ec"
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
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL,
                 shell_output("#{bin}bloaty #{bin}bloaty").lines.last)
  end
end