class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.4.2/cmake-4.4.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.2.tar.gz"
  sha256 "1db9e61e60b6e0874c86386340b910382f3c5e75b9fbfb44d122063129a2789d"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78cc911818589c56f42f91db0ec3daa514b89dc6fd7b67a1bec8a44901376edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5251a447c1439c293dd3710cb641d53552a2be13c9e48b8f24f6546f40e726a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b064870852fc1c3215df4e9fce5447514319be9a318507810e102eaa74e4bf5"
    sha256 cellar: :any_skip_relocation, tahoe:         "d442d92e3005da20eba9d5e17a910843a1c52da6ae94b0aa444b9a1e3f3a852e"
    sha256 cellar: :any_skip_relocation, sequoia:       "28aa07b4508d4d14fdf77a30274cd7b1f85a4f3cb29f02b531243f1369074844"
    sha256 cellar: :any_skip_relocation, sonoma:        "e10055c3703494ce63a07ab3f2f36e04cc5618779fb83d5440358add7a70bb47"
    sha256 cellar: :any,                 arm64_linux:   "7d2fa78e71ca0b9d95d9f26dcc9ff6d5d6d8f53be2667046f16cd137396b98d4"
    sha256 cellar: :any,                 x86_64_linux:  "5b44cb13b7e50d878bd1e0512030ee6d3aa192fe5f405d65488d48a7f1db21f4"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake-app"

  deny_network_access!

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"

    # Move ctest completion because of problems with macOS system bash 3
    (share/"bash-completion/completions").install bash_completion/"ctest"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end