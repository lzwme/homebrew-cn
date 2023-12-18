class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https:www.supertux.org"
  url "https:github.comSuperTuxsupertuxreleasesdownloadv0.6.3SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  revision 6
  head "https:github.comSuperTuxsupertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "10852cf7b4740312c1e5ba67d487744d69d5583539b4c9f62f3a898612a8c87b"
    sha256 cellar: :any,                 arm64_ventura:  "ea036fefea735c4d01b354f6262903ac3bc7d00bb024d949a852952b5a24c6ae"
    sha256 cellar: :any,                 arm64_monterey: "11d6ac1caab26b4922866fca32e7db3a684ee57727a48c96c8de8aba8543c972"
    sha256 cellar: :any,                 sonoma:         "e412155b34b8093bdbf2e085705ff40c3afb2b040095ad1278db9542f9cf7c53"
    sha256 cellar: :any,                 ventura:        "1bcd07682ccb0f06a775e5d002dcf11986bd2f891a3085ebfec1b5fe2ae50523"
    sha256 cellar: :any,                 monterey:       "8300e258fe02b48a4075731689a42d917d93d0b47a3b67438759483f224b4529"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e82f3dbe4f07dde17554e9df00ce014439003f8bba86bf0ba8491e90330e06b2"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openal-soft"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=sharesupertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    (share"applications").rmtree
    (share"pixmaps").rmtree
    (prefix"MacOS").rmtree if OS.mac?
  end

  test do
    (testpath"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}supertux2 --userdir #{testpath} --version").chomp
  end
end