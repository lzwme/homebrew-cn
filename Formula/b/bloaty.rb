class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 40
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
    sha256 cellar: :any, arm64_tahoe:   "9f9eac5e929ab7ff98d1c7e72a3141af8e60f680cba3b01d361caeebe5e83f5d"
    sha256 cellar: :any, arm64_sequoia: "d212c8b3752a5e41898da81efca2cfc4c7acb0a7513ccb5c062bfb04b509730b"
    sha256 cellar: :any, arm64_sonoma:  "8c8fdb47b8d542f08b5dd9551b31acea337bc3594ddca79cee9996a4eee319b8"
    sha256 cellar: :any, arm64_ventura: "7dc089b9e3efe24537b5eac60fcd7c1678c309a02243e4217104f49b847db816"
    sha256 cellar: :any, sonoma:        "b038887862211dc19ec42cce9a900a882b4ddeeec39ccd883fb2d6c64c47c9d0"
    sha256 cellar: :any, ventura:       "f04816100bc5a4a0938934b2679382d59a57b3b1638fdb68c49094e8bd2e0f2a"
    sha256               arm64_linux:   "e10284341ebca066b32b286d61cba71986b3fe124767d7f0d3d2c62981af4008"
    sha256               x86_64_linux:  "6b18bbbfe697dfc6bc915c30bcf12fb0d94fa5529e3a391188a32d678b86b334"
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