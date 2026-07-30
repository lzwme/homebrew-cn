class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.4.1/cmake-4.4.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.1.tar.gz"
  sha256 "95d4721f3625fb0d9d6ca480dd59a46c84b4c157f7fadd2e9b179ef9c871174d"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2a325e07829b2ddc214556692920ab1f3826ea6f0832c5ca6f00e84beb0e465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d809f4d9889426cce216eecd2a804ebb4a05aa869470884612c20c3cb74feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5a1987df52c5217538a00c0a7be7767f4d31885cfcca010a3a8339ad989cb5"
    sha256 cellar: :any_skip_relocation, tahoe:         "e7dad3f1bb7a6c05ca322dcd69893259bfbf82d5e057e1bb27a5fb715f27e395"
    sha256 cellar: :any_skip_relocation, sequoia:       "c82161c4f81805cc18775e6ce28d475a067884dd4a76bfd6f53cfe6a8b83d21a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b739fd74eebf189a66207f4dedb1e6ab96882f05cd1d22c07d13df84be55c490"
    sha256 cellar: :any,                 arm64_linux:   "721b77812bbacedb2285864d1fe7254f561935df406392cd815b5b2d0f92e676"
    sha256 cellar: :any,                 x86_64_linux:  "05339e33d914ede9f128ed9b928ce3331461347628e6daba911be4b921f89804"
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