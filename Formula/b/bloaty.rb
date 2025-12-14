class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 44
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/bloaty/system-abseil.patch"
      sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a3b4c5a5b27a5ba273b2b7a1fd34d2ba0798b1dc4ba333b6d6e3d5fa8c590840"
    sha256 cellar: :any, arm64_sequoia: "82c6c79536703aa6ef95ee29af7501baf710f42275aeb746f0eeb53f78f144f0"
    sha256 cellar: :any, arm64_sonoma:  "2d2540ebff2617bf68e481155cd0d9a21c6652dc9e9eb18b63c8522b74585106"
    sha256 cellar: :any, sonoma:        "d1a3dcc3d9d2dda73e9696a600e03e07928ee12954e0b803754092fcc5ebb8e3"
    sha256               arm64_linux:   "8b836d6a3f88992c0b8e595f925dd4c31dcd9965e56bd69a6d608567bd748f64"
    sha256               x86_64_linux:  "108d66f2cc2edd4fda4049da1ddb75c2f7510e2086bccdb69836f93843064fd0"
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