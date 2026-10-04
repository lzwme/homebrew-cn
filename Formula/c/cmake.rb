class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.4.4/cmake-4.4.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.4.tar.gz"
  sha256 "bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e18887e41e77de2880e14a8adeb81942279a83a22639bfab3371fa011340a73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e322ced61d82633061cf06f6e7bbfece429863f7fcfc8a959c2e94587a6f4a67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f5a61638cb59a8dd74d7d15d569c9e350ca19219f9d5c7024b98356f0bafbe5"
    sha256 cellar: :any,                 arm64_linux:       "6123eeb013305ad72ce9e3f2e47946b442bd59957fff5fff5cbe089aec306ee6"
    sha256 cellar: :any,                 x86_64_linux:      "f88edd266381d550caa776caf394d57a4f933123da0d1aa00a2b49e976e8b20d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

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