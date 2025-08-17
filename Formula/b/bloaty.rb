class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 39
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
    sha256 cellar: :any, arm64_sequoia: "47a02a9c21f0ec00b443a0b2d92533d81bfa8ec76b10c1f6587be2f1d9e723ee"
    sha256 cellar: :any, arm64_sonoma:  "46b054cf9391e57c6ad02daab0f2a1d4f33ff38527cff3cb527c0acd427cac8f"
    sha256 cellar: :any, arm64_ventura: "4182c2d976be5319840b6cdea2253ec5fea2f847893a5a141301a55317ca57c2"
    sha256 cellar: :any, sonoma:        "3b083ee464bf16a35ee8b7db68c5f504bbf7ec7587b7ed68ec0b640b71edc89f"
    sha256 cellar: :any, ventura:       "53a463530d695d283613273d76bdfeb32e67c356d9152381f359013f6f21dc38"
    sha256               arm64_linux:   "7c518d919f5b6ae0f44a231324f4de188df4c5c3f199953f3ef7d108aff6d25f"
    sha256               x86_64_linux:  "aee6b1860f51420217faf9d5b407a1c94d47351ab34b1e6ccfb43fb63b4963ec"
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