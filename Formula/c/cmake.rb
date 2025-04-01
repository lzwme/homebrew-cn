class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv4.0.0cmake-4.0.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-4.0.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-4.0.0.tar.gz"
  sha256 "ddc54ad63b87e153cf50be450a6580f1b17b4881de8941da963ff56991a4083b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb331a5d068e16a5a5527b1b3caf5cc7ef67f5ce34e24bbba4a90b54b2f9358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273335ab9a4ca7f18c396e541d03f0cff78fc253e9d0f9b72c5dbf9bdf91f9d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7da3595e4df8909cd8022fe03aeeef637b49341d2659a129cc33b83a2a1099c"
    sha256 cellar: :any_skip_relocation, sequoia:       "b063bb9e965eac8d3b1d0c6bd7534e46151941216ecb446cf8c888b82d66bd98"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f2c55cc59fef9ee0a6168f43faba88b86dfcb44c7cac9e72d929cefcd95214f"
    sha256 cellar: :any_skip_relocation, ventura:       "344028fcd69364bb477556b7ff76ce1e6d76717d3bd8864e8e2feb1316fc1f8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97cd0f2113d29664117efff550f028d015bdda3a5e3e2dec54dcfe40d82924f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f8cd5f476e7841d6e4dec76388fb59194b1d44e0fbd5061f3dc70240c2b4131"
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
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc"html"
    refute_path_exists man
  end
end