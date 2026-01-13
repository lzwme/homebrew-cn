class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 45
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
    sha256 cellar: :any, arm64_tahoe:   "1f785f2534938dfe5cdb8f3b6ee7198b0d782dd7495e13904451fc971d16aa6f"
    sha256 cellar: :any, arm64_sequoia: "894a5b33890f3ccd6f111ca8fc12529ee89f587fa48fb6758a08c320f59b07ac"
    sha256 cellar: :any, arm64_sonoma:  "ded4855fd2ab9c4d8f6e6e79f4dd866502d1dd35642d79dd29ea33e1025872ef"
    sha256 cellar: :any, sonoma:        "d10b09b9100d1dbae1f73d4f33b2d1e1c3129c2fbc15ec4fc6badd58b7bb147a"
    sha256               arm64_linux:   "aace88559daacee6e850902d94fd2bec2184c65fa8a398ea553aff6fe67a99b9"
    sha256               x86_64_linux:  "d56cba32081741cf94f86d3ab09f3a496aa9d7a5827e6eeebfcbdd49863483ce"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    # Workaround until new release with
    # https://github.com/google/bloaty/commit/9677d4938ec5be44f04eae774c94e10d339fd3a7
    ENV.append "CXXFLAGS", "-include stdexcept"
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