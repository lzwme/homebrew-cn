class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.32.4SDL2-2.32.4.tar.gz"
  sha256 "f15b478253e1ff6dac62257ded225ff4e7d0c5230204ac3450f1144ee806f934"
  license "Zlib"
  revision 1

  livecheck do
    url :stable
    regex(^(?:release[._-])?v?(2(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08f89dbe9bb9cb9e002636306ae4a697ea4fe7d67a1df2fb47fd3f57e4e0dcdc"
    sha256 cellar: :any,                 arm64_sonoma:  "f50bafd64c1ace3f23e1ff487e14521c3ba19841e27c2a36ad0d36e037e01ccd"
    sha256 cellar: :any,                 arm64_ventura: "c6f571fd78f4cda594c91a47bf4f9610ebd93b80919d377838978be3e1f33152"
    sha256 cellar: :any,                 sonoma:        "ec3233a09088235c3d0b6da4918cc04216538f0ef9eaf24b6305ecf9d80fdac8"
    sha256 cellar: :any,                 ventura:       "d2ec5d4906d9d243f4003f46e572188250983aad5fb10c05377c6b12ea4882d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a784ccbf6c77e5a4f38ff0da4b6d8e04177b5c3b8bb59d1023abb4881124173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de07836c3ee3391fd325674c35a2c7b9bfdfc4c01a9bb38ef32081af1dd5b77e"
  end

  head do
    url "https:github.comlibsdl-orgSDL.git", branch: "SDL2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "mesa" => :build
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "pulseaudio"
  end

  # Fixes a crash when game controllers disconnect
  # https:github.comlibsdl-orgSDLissues12807
  # Will be fixed in the next release
  patch do
    url "https:github.comlibsdl-orgSDLcommit7fc5edab8e939523dba9e10b6375fcdfb0f875f4.patch?full_index=1"
    sha256 "e6275f870e77bc91b0b171e9a4c88be480216c48886e23967af2a4655ed8b978"
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