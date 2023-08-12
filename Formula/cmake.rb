class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.2/cmake-3.27.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.2.tar.gz"
  sha256 "798e50085d423816fe96c9ef8bee5e50002c9eca09fed13e300de8a91d35c211"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "014b264a24fd5c3fe453a3f0946c48fe43e3dfeeb6c15cfc444b8f92129c7ca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d898ca96262959b076ed54569af37651a32fba6350bcce0b86fefbf79602765"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3bdd96b6da5bc599720d94ca1028cac617ef8c04a679c597f79c17126f9d537"
    sha256 cellar: :any_skip_relocation, ventura:        "86f1c2132b9e1e84f989f5d1a684496ee7763656e9f83a9c3da8a97bf0c60a91"
    sha256 cellar: :any_skip_relocation, monterey:       "d0f4f2746605b4dfe4f0bf3835cb4b2bf93e654690ab5fb870642ea6138f887d"
    sha256 cellar: :any_skip_relocation, big_sur:        "59564e2148f4080a885bf2960efd242816469b857c5728303c85e487bd95bda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d98d56bf75d24cc6da98b186db16878f65dd60192d891209198af94ec5e20b"
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