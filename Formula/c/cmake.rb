class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.1.0/cmake-4.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.0.tar.gz"
  sha256 "81ee8170028865581a8e10eaf055afb620fa4baa0beb6387241241a975033508"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2ee3355e256efa31d82a907265e646d0d48c49cae5b2edd3b578b55190dd7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd7079f2f2233ccd4572622e12adbc833dd6593c6d7f5a6839b714203212a18c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c33a4a38b6fc7e2c66c75eee60965ee9823f1f65f450fca90d4acbbbc3a1ea5f"
    sha256 cellar: :any_skip_relocation, sequoia:       "173bc3d38c7b5a3d73faa5459f6d776571d9559d1af9a1215c0455aa48773991"
    sha256 cellar: :any_skip_relocation, sonoma:        "d619019c8847f10e88a6d7ad4daea818ca308b650b2cc820bf14a682fdd5e0d0"
    sha256 cellar: :any_skip_relocation, ventura:       "23c0791840f8bbc69020c4af7fee7e161944df1513cbf9137d7d2336d34c80d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a77632d2b06fec7f669a0b58141c1a940fc087c8e9a6518ecfbc5387312662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff373edc86395f53437056b4cae45f3c6dcc78609f1a482e7f1ea09cac9aa5e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :high_sierra

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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end