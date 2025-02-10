class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.32.0SDL2-2.32.0.tar.gz"
  sha256 "f5c2b52498785858f3de1e2996eba3c1b805d08fe168a47ea527c7fc339072d0"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](2(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19b6d2acc8b60e698e2eef31fd76ce9cada73e592056719a7ba726fabd51d59b"
    sha256 cellar: :any,                 arm64_sonoma:  "d060098946a48523b21a2ad7b53d4dd588ac710556062c9bcd5d41ab26971424"
    sha256 cellar: :any,                 arm64_ventura: "92b207b50e62d25468d9a4d8a2d66cb5b2b3803f6900f7b8c08059567b97be2e"
    sha256 cellar: :any,                 sonoma:        "c0e52e23ce85c9aac1616b9f8f29e60ee8ec68569c5d4a4e85df74508aacc736"
    sha256 cellar: :any,                 ventura:       "7f216df6be986bb8f21bea1a76f582d999ed2e0c67b2d877add461c50bc5b097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab39f7028ca5c300cd58ed4cd1c9f404a5a906a457f26f2ab984edf5801a026"
  end

  head do
    url "https:github.comlibsdl-orgSDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
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