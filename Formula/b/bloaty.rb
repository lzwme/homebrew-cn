class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 35

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3903a8c98c15249ab765ea00d0def107762b404593bf37cc48366fbd02eb3e4d"
    sha256 cellar: :any,                 arm64_sonoma:  "6b477734eee3c9d113edeb730761bc756567ad354e6311754c3b616f10f8697d"
    sha256 cellar: :any,                 arm64_ventura: "bd59a6875bae0cc0f13328acac97d2bd32585768ced1881783411674bcc163bd"
    sha256 cellar: :any,                 sonoma:        "e4cbac251b0b57d7a720d861620d0612002cd844ed53a26d65e3b8543b6cb0b5"
    sha256 cellar: :any,                 ventura:       "be03dd99e7bb5d942650a94edbec4c2500ec388a0de91b0af68ef6aae4eb3e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954903225e6903f0447d241e1a9bc42dab9ae66e5aff78d5b1cde950261bea40"
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