class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.1/cmake-3.27.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.1.tar.gz"
  sha256 "b1a6b0135fa11b94476e90f5b32c4c8fad480bf91cf22d0ded98ce22c5132004"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5eb8797d854a1874a0822db10975a4c04de2d821a1c58dfb61a74fd666b2a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0342d846bff736b3fa37b459b64487f564dd4b884ec4495b4e8025d1f4f82874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63b57ee981fec3ae511471d970c7d4bd426a3f51650a18994033291f811973ac"
    sha256 cellar: :any_skip_relocation, ventura:        "89ffad1003a0c4ce5f0a0a7fd3a7fd9f06dadd0eaaa2d5786a242e8d8ccef955"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ffaa39f9adeb673de7719c2e815c75a665c8778fa52594e4defff1307c0af0"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a297bbc9e5ebb237dd8c8fe9b0c84c2cc32a4e4520932698c83189d62c256e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71baf318f1a02cdc0b6fb8d5c710258b28097687993868ec318f479a561e328"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

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
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end