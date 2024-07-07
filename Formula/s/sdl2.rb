class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.5SDL2-2.30.5.tar.gz"
  sha256 "f374f3fa29c37dfcc20822d4a7d7dc57e58924d1a5f2ad511bfab4c8193de63b"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e9b9b1a24ad6a8c05d0858730aca5f75ae2b1197a312416151533f367c7c037"
    sha256 cellar: :any,                 arm64_ventura:  "ee1f33db9be6386e45e0fd81ab48deea2d565dc6dce5b3fa83d28d19793803f3"
    sha256 cellar: :any,                 arm64_monterey: "cda59dd78051e791fb83fedc121f96cbdee035ba300256b4a149c51afad73045"
    sha256 cellar: :any,                 sonoma:         "2b7c4db615f81e16fe8d952d4dd27901bec2c85c7aea956c3d91d42baf76879b"
    sha256 cellar: :any,                 ventura:        "1a78cbffbc95d76f17a3575ab8acf529b711c9913cf8337011e43cbdfc26d997"
    sha256 cellar: :any,                 monterey:       "fccef8c11880a12af15c5858aae966592ef68b2ad1820c222418cc4db8782922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c38de35a37756e052e78f8951fa0fbede0d8f47f97cfae58d17de97ed2c50a"
  end

  head do
    url "https:github.comlibsdl-orgSDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libice"
    depends_on "libxcursor"
    depends_on "libxscrnsaver"
    depends_on "libxxf86vm"
    depends_on "pulseaudio"
    depends_on "xinput"
  end

  def install
    # We have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace "sdl2.pc.in", "@prefix@", HOMEBREW_PREFIX

    system ".autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --enable-hidapi]
    args += if OS.mac?
      %w[--without-x]
    else
      %w[
        --disable-rpath
        --enable-pulseaudio
        --enable-pulseaudio-shared
        --enable-video-dummy
        --enable-video-opengl
        --enable-video-opengles
        --enable-video-x11
        --enable-video-x11-scrnsaver
        --enable-video-x11-xcursor
        --enable-video-x11-xinerama
        --enable-video-x11-xinput
        --enable-video-x11-xrandr
        --enable-video-x11-xshape
        --enable-x11-shared
        --with-x
      ]
    end
    system ".configure", *args
    system "make", "install"
  end

  test do
    system bin"sdl2-config", "--version"
  end
end