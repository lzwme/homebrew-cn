class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.32.4SDL2-2.32.4.tar.gz"
  sha256 "f15b478253e1ff6dac62257ded225ff4e7d0c5230204ac3450f1144ee806f934"
  license "Zlib"

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b942fa2153404b4ddb138153432d57a09715f1a66e5ce76b05d838e1980b6e98"
    sha256 cellar: :any,                 arm64_sonoma:  "bd16f10d59f32856cc2a39f82752f988300efa56a0b0f836f1c18bad4715781b"
    sha256 cellar: :any,                 arm64_ventura: "a64929baa62d649a79c64107a942c48ef659d8504c59d896137f8758abfa28e4"
    sha256 cellar: :any,                 sonoma:        "61f9b4812e65459c46e3b16694afdc85352b4d4352e006f76c7aa2c3e2278720"
    sha256 cellar: :any,                 ventura:       "1f3d11654b35815f560b1d6dd515b2776c2a23ab8a11b30ccac8a12bac602c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6948b8e27ab47ce22a27133198c1fb37847361bbc7225ef745b28350b69f650a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6b8538e6e4bbf03fd2b9117424fc1ebb444ece7cdcf02d3bc8afa30ec12af9"
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