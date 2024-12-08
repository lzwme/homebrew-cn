class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.10SDL2-2.30.10.tar.gz"
  sha256 "f59adf36a0fcf4c94198e7d3d776c1b3824211ab7aeebeb31fe19836661196aa"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2c39e2f53a61b0345a7322e6bd2013beedc80bcc322021e3aec2ccf7ebb58c3"
    sha256 cellar: :any,                 arm64_sonoma:  "feb84413c378c66af6c20985bb1367c455ea34f14d6be776f6d7a3afc4ca0f1f"
    sha256 cellar: :any,                 arm64_ventura: "5ec54e17cdea933dbb9daf9cc2101664dfd783ff70bcdaaca675dfdeee3d7ccc"
    sha256 cellar: :any,                 sonoma:        "990108b87ff3f117fbc9fbf9648e093a32edb435cf192bd0c42b3a97e7e1ddfe"
    sha256 cellar: :any,                 ventura:       "7cc5a03c3ac21e51fd11f2d9b5f445d1233c19a41d0ffac3dcb5274383b08e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b331d26576b3c1255b350fb7ce8beebb93f96a4a8badd6199b94c735bf9d75a"
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