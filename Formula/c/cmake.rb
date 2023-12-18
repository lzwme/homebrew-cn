class Cmake < Formula
  desc "Cross-platform make"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.28.0cmake-3.28.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.28.0.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.28.0.tar.gz"
  sha256 "e1dcf9c817ae306e73a45c2ba6d280c65cf4ec00dd958eb144adaf117fb58e71"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5a4b03e2dd6527ec0f5844f2f0e0443b6873c584b6cdbbca49a782277f5d9e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c813283a994fa5ea104e04ef5abec5ce18e361326864633346c5425a31771ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc59d117c0a2278c15ce0f8f0c60f468b41e5d2a486e8fbb68c0757a8a3d690b"
    sha256 cellar: :any_skip_relocation, sonoma:         "847553448d22114017065106ee395cf93a53ed17b00e8ede636bd75dd00f57f9"
    sha256 cellar: :any_skip_relocation, ventura:        "198d5e1e8c49b3377359fc660d4c52e72aa374496de0bf92ab656f6e4af961a4"
    sha256 cellar: :any_skip_relocation, monterey:       "a40043822fadcf4aedad551e709fa7a8786ebf49f9cf738b90ab7211734abb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f172491b2a2430efc03922177de60fbde855b10c10f07df9acb8ad3e6839ab"
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