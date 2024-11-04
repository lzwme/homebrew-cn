class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.9SDL2-2.30.9.tar.gz"
  sha256 "24b574f71c87a763f50704bbb630cbe38298d544a1f890f099a4696b1d6beba4"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbff6c079fb44cb4b568dddb0a69c5da08b396fe6f6a4c90618f2fe8486456ea"
    sha256 cellar: :any,                 arm64_sonoma:  "84704c6ab26482890a172d9da912fbe51656de29caea75e46e287397f60461e0"
    sha256 cellar: :any,                 arm64_ventura: "a8168508bbddc2439d5434b85b3fd4fec4f8b5cbbfeb11dc4c4b33faadaaabff"
    sha256 cellar: :any,                 sonoma:        "e0e36f68524a09d5f0b9318b8ce905a4d3a87408eea94a238084075e55bd1176"
    sha256 cellar: :any,                 ventura:       "7726275e371a832296395ce5e0d3988ccca358d1ddba82d384be5a9dbdc4c23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc21173917029b88754e65099236a393bf42e5f3b07f100977140ba4b7f71cf"
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