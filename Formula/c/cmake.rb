class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.27.5/cmake-3.27.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.5.tar.gz"
  sha256 "5175e8fe1ca9b1dd09090130db7201968bcce1595971ff9e9998c2f0765004c9"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6a0dba1e398b90aa6659bff6062d03478fe32fabb6fb72c58b0bbae03f9bebd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "787c8d1116e93c7ae7840c84b7267e3525cacf8e435e07141f6827204d62f3fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfa14e2c7e6803d412417468b874c921e078679af7b5ceb1a9215ff4ffb84df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03abcfd95632f14c9c14afe8099bc6b897a8e5fc78e67fdd93a9ec6c11877b38"
    sha256 cellar: :any_skip_relocation, sonoma:         "d560d2998b5155048cb94468ff0a98aea627284323c35df99ace59a30baa07b6"
    sha256 cellar: :any_skip_relocation, ventura:        "ca82bae94a8fe3eb23f30b54168a9a268377ddea9f6976068ed0b63e1729adc1"
    sha256 cellar: :any_skip_relocation, monterey:       "140603d9721610620e17dc1cd3cb108126fae140f07e4745e7ddf06a988aa287"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4c0d27cdc3122385ae56b287a6a4037649538710148c2df29febaf389ef2b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3836dc681e266f670c8749168a43d53108bc9378f6bd621b6e793483ec781343"
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