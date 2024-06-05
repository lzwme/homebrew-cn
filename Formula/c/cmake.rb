class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.4cmake-3.29.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.4.tar.gz"
  sha256 "b1b48d7100bdff0b46e8c8f6a3c86476dbe872c8df39c42b8d104298b3d56a2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb50c637032d9d68717d6b28cbf1c31004d417e817ec559d5637ccd4ace3d325"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c7b3698f98d5bcfbf264d77e4179d1d933ad37fa9db7fdbac6c8edaa19bc21a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1a0878dec2edfdd941baacb499fd020e3ccd10339f48d08123e20718fdbd83e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c63612a9f49827050bbaa26fd51d528c3587c0e78796993edd7a2ad44879212c"
    sha256 cellar: :any_skip_relocation, ventura:        "7f43e59fbe8779a38741b0f55d41f7a9de5e16dced8e788f00a7462971fc7811"
    sha256 cellar: :any_skip_relocation, monterey:       "ab350fcef6caf265962cc87022da1c23c0e82d96dc84ca86e0133b071c5f68d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7649cc7253806b664d5708fdb064c59b98f63b78f9f82c7b85068535676c4605"
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