class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 29

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5ece9c803b6a51a88b040f05fd9f9ecba504860be327aaae7f3fbca32ceac10d"
    sha256 cellar: :any,                 arm64_sonoma:   "0760d9714260ab1b90f47f6aa4a650693668111b2453c8aae2a9f90f3f5ed7f5"
    sha256 cellar: :any,                 arm64_ventura:  "90f8e8c37ec415bab07e5e181d040cd0ea6138953c1c2591cc02d156296cddc0"
    sha256 cellar: :any,                 arm64_monterey: "35368f7f27988976ec100daef7a5c7384c47104d2d55f8abec91d2a91fd74c15"
    sha256 cellar: :any,                 sonoma:         "9c2e304f0c4b2f7fb8f0837e71c270ab7c893a26af3b747ca79f73a548051bd6"
    sha256 cellar: :any,                 ventura:        "486f6a457e96094666477fd053f81fbaa59b6c0aeef264568d32463b6b903374"
    sha256 cellar: :any,                 monterey:       "c5e3176dfb63c50f271803dfa862e2df44f3ad581ce7e68237b4fe1044217c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172d62668120f6fd2aa9993ecf96e18ecd4e6eb90865d52cfd966ed336779ad0"
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