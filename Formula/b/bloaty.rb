class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 42
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
    sha256 cellar: :any, arm64_tahoe:   "540b073368aa5403c4f3842c0159187e1775a8b5eef8dd564179d38277e6e9fb"
    sha256 cellar: :any, arm64_sequoia: "048ca4fdf23adb247adbe883437ff6a9d29b0c46b6b84dd0eae7f84b39e0e040"
    sha256 cellar: :any, arm64_sonoma:  "eab4853f79751d93764cb87491bbab3a401cc7155800382f82d6cc1ffa0e7446"
    sha256 cellar: :any, sonoma:        "ae2d1ee8e7b9502d5b4a86e5d320b8184238ce3b300a7abe7b7677db8a9274c9"
    sha256               arm64_linux:   "48924fbed0ebae06151e324b8085184084b8c788f4d1351737bfa72897eddfcb"
    sha256               x86_64_linux:  "2efb5b644e72f9175cae764a3ab17d9dfe110e11f4c077430f16d9df69896d9b"
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