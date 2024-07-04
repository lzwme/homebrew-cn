class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.0cmake-3.30.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.0.tar.gz"
  sha256 "157e5be6055c154c34f580795fe5832f260246506d32954a971300ed7899f579"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eb265cf09f23ebab2f4b5cc463150a8cd1004b480e43496593bebec24eb49f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e0b599c1a9fd9e3ade591d0373ae73480088baaec0f6a021fb7a9587e33e20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ab549f9321c07ca25959dac83fdffe842644cde1952f12389618a44b4c233d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "755feeccd7b416faaffda0913439f83d9407f0cfb236379e5b593d26796d4330"
    sha256 cellar: :any_skip_relocation, ventura:        "49e0f45a1c729a611694531bb11e24a93778ab03e3b811101548fe4d1ef20c4e"
    sha256 cellar: :any_skip_relocation, monterey:       "52e1f8fb713dd78b51ee97225a925023acfab2907dfb4ae16d69f3b759e52694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96861ca124424d2061b00e6727b19f1490e79fae34c9e2e7f488d43cd0d0e285"
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