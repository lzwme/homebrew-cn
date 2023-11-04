class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://ghproxy.com/https://github.com/libsdl-org/SDL/releases/download/release-2.28.5/SDL2-2.28.5.tar.gz"
  sha256 "332cb37d0be20cb9541739c61f79bae5a477427d79ae85e352089afdaf6666e4"
  license "Zlib"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e24661e6374f63b5db9ee3cbed7da4859f6ad0fb42883397a341d18adb6b0093"
    sha256 cellar: :any,                 arm64_ventura:  "901a5a95703bcc37cf9eb77385dd29cc02363e3f26a7f42cf4c1d4661f68a680"
    sha256 cellar: :any,                 arm64_monterey: "d7d4727637c8cfb14028397e8a9cdbaf77ad38ee2fb6292e8ed1dd182968eb0a"
    sha256 cellar: :any,                 sonoma:         "1234407d7c411b9f7425ffd8f84957f21134aef3f2460be5d0f23daf98cf34db"
    sha256 cellar: :any,                 ventura:        "29a9910aadc2fdd0cf9815c5547645f50afe9af575089c085a9425d71c11f209"
    sha256 cellar: :any,                 monterey:       "db5d0117c390ce877849edae9ac6db29b560a5331a3d3684e251575d0f86f9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b14e024bcb1fac833616aa02474d1e31ab7d58b26be2677ac8688f18d00fd8"
  end

  head do
    url "https://github.com/libsdl-org/SDL.git", branch: "SDL2"

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

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --enable-hidapi]
    args << if OS.mac?
      "--without-x"
    else
      args << "--with-x"
      args << "--enable-pulseaudio"
      args << "--enable-pulseaudio-shared"
      args << "--enable-video-dummy"
      args << "--enable-video-opengl"
      args << "--enable-video-opengles"
      args << "--enable-video-x11"
      args << "--enable-video-x11-scrnsaver"
      args << "--enable-video-x11-xcursor"
      args << "--enable-video-x11-xinerama"
      args << "--enable-video-x11-xinput"
      args << "--enable-video-x11-xrandr"
      args << "--enable-video-x11-xshape"
      "--enable-x11-shared"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end