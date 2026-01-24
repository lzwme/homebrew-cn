class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.2.2/cmake-4.2.2.tar.gz"
    mirror "http://fresh-center.net/linux/misc/cmake-4.2.2.tar.gz"
    mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.2.2.tar.gz"
    sha256 "bbda94dd31636e89eb1cc18f8355f6b01d9193d7676549fba282057e8b730f58"

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/Kitware/CMake/commit/6347854fa279cda0682c72dffbb402a0ce29ba51.patch?full_index=1"
      sha256 "d0c0b08826fc16468dba8672f8a6b77c56062bead4c5c501360e868e511ee91e"
    end
  end

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eeea08a18c94f5db07c6d9156bef40942c6b0bfd9439485ea7ed65b283fe20f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10a21246d23fad0433574e13dd997653bb00cd23ac54f4b8c9d5a6969ebd3bbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98c904ea38d37cd272deb3375561731dbf927e5fb307d48534536e55b2b247d0"
    sha256 cellar: :any_skip_relocation, tahoe:         "99dd33767b64ff4ad0aec416a67b3c2aa008416243c66e01679a2f7382b7fe19"
    sha256 cellar: :any_skip_relocation, sequoia:       "4d39186960cbbdf3d88013c6d326e07884ada7c7b98fe125c76a02b372aff93f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0e0dd8ca0d3ad4981e17ea2c0657d712b31aca1af4d2ce3d413947f36047963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e920cc4cbccf4d5d78e5589fea910cda2b054f7dac34fcf3dc82c96ca3faa122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d356f1c01e3917f11edeaf048510bc56457442f871a5a66fe5b71b23757edea2"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake-app"

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

    # Move ctest completion because of problems with macOS system bash 3
    (share/"bash-completion/completions").install bash_completion/"ctest"
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