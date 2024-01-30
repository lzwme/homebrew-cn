class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.28.2cmake-3.28.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.28.2.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.28.2.tar.gz"
  sha256 "1466f872dc1c226f373cf8fba4230ed216a8f108bd54b477b5ccdfd9ea2d124a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e64e37539642c97133e04b679f4ea861ca3d88a297338c9f5f877664eff6e9f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad0b3f433f9bd61f69cec442352de055041dec228cee6481eb58a78f3b1c1599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad87d1d3b9d2695405aa021ba32ebf65f7a86a729d98f7d947083a75686d33f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e1f47597506969d7b7c000f306236dd9c8631de5058456b7d611a5f4794d9ee"
    sha256 cellar: :any_skip_relocation, ventura:        "fc24a06ddf026740ddab5c133533d619bd2f1591c09cb1349c04c074bd1629c5"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3ce9d4cd46b4d468ec6cd0c6920b7be5847466adc1796932918de83f067eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e535d7b4f16b2c7e024655c284be4c135ce44f5575df3e6d0b1773d9e261082e"
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