class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.3cmake-3.30.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.3.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.3.tar.gz"
  sha256 "6d5de15b6715091df7f5441007425264bdd477809f80333fdf95f846aaff88e4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1e7c136431f5c38e08f73d118374d69fc8055d8053d7d17fb0399c29a9bf2a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad9ad76e14c46d5fcc727322002e230bb9fcfe71db1453defdf9875c1fd0a33b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69067a4226484a6a3c9624dadf324987004096b7f44f88bd9b69a09d8395641"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddd6fc37af08738bb5d9491e73ed37be64510065278425e3726fcd1b9db87180"
    sha256 cellar: :any_skip_relocation, ventura:        "a79c1d64879be94209752ad1ed3a298b954d6ea172202969b44dba977ce2ff82"
    sha256 cellar: :any_skip_relocation, monterey:       "9a06bae0043b8ed7c1e5cdacce018521fa3b9d4e07d86d0085b6ad5f9d03df7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44350707fa4af815fc981e274eb3b40eec87db45960daaf0c74a9d34a2ac5624"
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