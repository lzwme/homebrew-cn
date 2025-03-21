class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.32.2SDL2-2.32.2.tar.gz"
  sha256 "c5f30c427fd8107ee4a400c84d4447dd211352512eaf0b6e89cc6a50a2821922"
  license "Zlib"

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "98f8b604c3fbdc44b4350faa77e803e8b02497b17aa63ca7a3e85f25866483ec"
    sha256 cellar: :any,                 arm64_sonoma:  "abb098366b849a296e5e70542165ee4323d0a89284af3c43724c71359bd1f0d4"
    sha256 cellar: :any,                 arm64_ventura: "ea075701025a47cfffff4dadfc4d9ff856f9482139033ff402ffd2625ac84acc"
    sha256 cellar: :any,                 sonoma:        "dcb4346b86807ca1bc1e712f8f056962a32b4ed1841701d47c19618ed6c80d15"
    sha256 cellar: :any,                 ventura:       "0e743d7ffced7b00ef76580e9e1bcfcbbe364a547d48e673e039ecd7c1a34bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99ea3a3f30f53218a0d2c125037bf59aca877f0c3e0d9645b875bdb832b51e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c647481dc8fa2326636a4cf2fcc36b0c100166414802d6d0b592dc8e62eadfc0"
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