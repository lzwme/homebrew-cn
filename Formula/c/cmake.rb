class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.30.4cmake-3.30.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.30.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.30.4.tar.gz"
  sha256 "c759c97274f1e7aaaafcb1f0d261f9de9bf3a5d6ecb7e2df616324a46fe704b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ddd00b4b6d7cabaee192d0200df2eb403649933e07c550e882ff63bd350b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2740681adb8c207bbeb8146ceb34696b245b83cf1029820e29c10dad0bfa44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92ac7e87939acf0bbbaf57d786c85ca22fe50df534a50f1012754ea3d822df8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3699243666cf816ac04b5c812a87adb065e2cc98a5180051504fea59bfb745b0"
    sha256 cellar: :any_skip_relocation, ventura:       "ca7509db8f0b79f5c713ef5596644f2c184b61626eb6721f89b4b64675db11bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040464fe337668bbeb616f8b82996d4a1461478018d235582f751d3b5d987c34"
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