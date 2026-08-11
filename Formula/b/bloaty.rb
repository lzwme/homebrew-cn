class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 51
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      file "Patches/bloaty/system-abseil.patch"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a97f6a6e553570db584915513abe19728664f08137ed255ade10ad54ddcf2c6"
    sha256 cellar: :any, arm64_sequoia: "8ba32e5d50c261e8f47834bc25ccb8b75f34e8223a2fdef0e8e843bcbb4c7476"
    sha256 cellar: :any, arm64_sonoma:  "f27779b6d37ab9764704e22a0bf5d7443d1514bcf9bca7873900c1f73c0de63f"
    sha256 cellar: :any, sonoma:        "f13af9f93ee2226ac4868a65e108966091e86e864b7d2530456178103334cb94"
    sha256               arm64_linux:   "06c3ab928975e77f8e7acddc6c4573ddd53e563dc73c578ac766508e35df44ae"
    sha256               x86_64_linux:  "74266469496d4b51d8803fbf82a1ed7cd8cea218297b31cacc8f17a93161f21a"
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