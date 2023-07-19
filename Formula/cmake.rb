class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.0/cmake-3.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.0.tar.gz"
  sha256 "aaeddb6b28b993d0a6e32c88123d728a17561336ab90e0bf45032383564d3cb8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eba3e4331ca75fafbefcbc31ea57b3e1f16242ec4c8188aadb22fb015820b906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1301c081b52a576f4d3cd885f7a59dcdad92e70dea4666b30a32ac76540a11fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b86102bbbacdd76e5ca60efa4d9377a62eac9ba59923ee1dd24720f0ca94b89"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe04eebc832537acefe046f69c9db8edfa9a1feb596b3ca85b003cbe4edbe43"
    sha256 cellar: :any_skip_relocation, monterey:       "08f455eb97db45ae187764d96fe9899677319bf102a85613da28ad128cdcc3bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3bbe0ac39bd13665f2ffd8d4aaccc5e2e968f37b8f9c0526df52d3fe321a7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784a477b1f262775f07aa469aab749bd151af7f73f9cdd19a4f8b474fb3d218c"
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