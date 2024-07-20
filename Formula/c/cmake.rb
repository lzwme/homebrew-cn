class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.1cmake-3.30.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.1.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.1.tar.gz"
  sha256 "df9b3c53e3ce84c3c1b7c253e5ceff7d8d1f084ff0673d048f260e04ccb346e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e4470bf5c6b14ca6e2f86c48d7e5b5e90e39d091d8066cb17c703d5e2ef0ce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3efe3c104c11f5ad3cd845eaa1e5408ef3209fdfc9c18f0f80263e093e25ac31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "654d34ee6520907135bfd90ed271ab461c453c372c9fa6d855eaf0bbfd056545"
    sha256 cellar: :any_skip_relocation, sonoma:         "282c7dee3a64006b3cfb4fb4c3f7e2afc103c1d9ca55d0eb372b938e23848a53"
    sha256 cellar: :any_skip_relocation, ventura:        "7c088a2eac92d059ab45f266dcae23cda4f26c97cffbef49e80d46c7125037d9"
    sha256 cellar: :any_skip_relocation, monterey:       "17522bdc0e79abb5dcaa09a4a6897211357a2fc819b0768db5a877192e9bfb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e927cf83f7d436e6b175006afd7fd25afbd4eb5f2894ba0714d98b3d3d645a"
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