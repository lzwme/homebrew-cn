class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.26.2/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.2.tar.gz"
  sha256 "d54f25707300064308ef01d4d21b0f98f508f52dda5d527d882b9d88379f89a8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7265f4017fd64c4344a0487b45390767e588fcdb35356bc4a82c4cafdaf7b3aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5be833e42eb508361de060f2639845159e2811e5eb7533900b1595812ca02d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "516244bfb0d5fdd0b7dff4598c0b4d558fa51289becdfe9e3db302d1c394ca57"
    sha256 cellar: :any_skip_relocation, ventura:        "1d4c11084ab2fb7a8740f2cbd3e348ad056295d70ac685e02232184605036519"
    sha256 cellar: :any_skip_relocation, monterey:       "ef28017af69b97687a0550ea357903273eb52edf6e2e25792593f8fe6b265035"
    sha256 cellar: :any_skip_relocation, big_sur:        "550d046ee4d856b2977af062066d4ce9deeb84d690bf9075f8461a3c479d9e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "429b67ac8e22d36af07d8fdb37fcc8dcbc3a6949e580f1b481335becf72dac42"
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