class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.1cmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.1.tar.gz"
  sha256 "7fb02e8f57b62b39aa6b4cf71e820148ba1a23724888494735021e32ab0eefcc"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https:cmake.orgdownload"
    regex(href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d9b7d484d371d2bb66452ebadd31034708c553ddcadab8097ed9911e2bbae31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cd076060f01246d42bbc507192d466d05b6cc430a0680eb6308b1c4c4cfb88e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262ae87f45fbf8f007e6220f64969dbab76f982a484c9d412ddcf3bc0917ffa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "04631ef4e4292c1315e12ad2dfb1ebb022e3677b908778278480e56a8e0140ac"
    sha256 cellar: :any_skip_relocation, ventura:        "ba061351890b139f712d48e916515b4a1baf16b1efb2feb8e5a63b63e22f6d47"
    sha256 cellar: :any_skip_relocation, monterey:       "042ac0a646359b5c6cafdacd066fa59cc5b99cac3130586836a44063450a857d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f253af3f526668a48602648b8461613e07c8388f1366211186c036602ca60df"
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
      --datadir=sharecmake
      --docdir=sharedoccmake
      --mandir=shareman
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system ".bootstrap", *args, "--", *std_cmake_args,
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
    (testpath"CMakeLists.txt").write("find_package(Ruby)")
    system bin"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc"html"
    refute_path_exists man
  end
end