class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://ghfast.top/https://github.com/Kitware/CMake/releases/download/v4.3.2/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.2.tar.gz"
  sha256 "b0231eb39b3c3cabdc568c619df78208a7bd95ea10c9b2236d61218bac1b367d"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e45bfc7f554994e0e1de6f1710d43d434f2e6e22f8a02cba767067e02654123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d671c4fcba89e0bef05cb6792ce74eb69f7195db9bade0365db94e4c329c3b09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ffb87e296144b33f5b82b1c49d5579bd56fd648d48389374c9739e24f3b41b"
    sha256 cellar: :any_skip_relocation, tahoe:         "4d87836c75b2608c0f6d02f53b202d810fb2defa0c87f986b880267c753908f7"
    sha256 cellar: :any_skip_relocation, sequoia:       "d38266b30cba32fe9fe3a5093e8a9a62c90b5c0f347af655e71e197316edc16c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a63fee74f42bb9db4d7acee5581bd94148a1c408e399bff9751ed5c3efa92d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4258af85b7b315c08962cba764f5ae025e73f6a7313b6ba2e98d48f9e962e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6bb79e9edfed3e2df71f3af9271f0782eaa76e3305a7a5edd49f466b2fef4d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4"
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