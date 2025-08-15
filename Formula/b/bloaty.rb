class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 38
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
      sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a27fad7dbd20d57537bf5f78dc38e426c632e69f5f4897304c0375a2b85fcbe2"
    sha256 cellar: :any,                 arm64_sonoma:  "8ebc0cb6d38c3ebfd89330a61e793b4a506a72cef66aa4be69a738f192256525"
    sha256 cellar: :any,                 arm64_ventura: "032603ee0817ecdd2f774527611a7fcfa20ae6ee85fb3b9cd1bae272725d489a"
    sha256 cellar: :any,                 sonoma:        "91b963bdd418682c5c76a4d8589f85989603d552e8585077f8b1bc45f81ae76d"
    sha256 cellar: :any,                 ventura:       "e78a2b93449dc47ca649d4763a24a2dcf3158472b6d9b81c916c469fd6f47d19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42347f1b78a35906bef29349371d069ffca4a9139e66cb918b4a707810a85d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e0ec2b146e541b5725e2307cd4c72750cd26321c5c1fa8a9942e18f7802bf4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    if build.stable?
      inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
      inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end