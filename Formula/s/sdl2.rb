class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.4SDL2-2.30.4.tar.gz"
  sha256 "59c89d0ed40d4efb23b7318aa29fe7039dbbc098334b14f17f1e7e561da31a26"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dd957c4ee6db3d8c8aa089e674c66de60b162cc16502a80638b6e96b6473425"
    sha256 cellar: :any,                 arm64_ventura:  "817d3677b593f20c95a1692b6fdc69a0f022084ae887330ed8dc0e03db87f6ed"
    sha256 cellar: :any,                 arm64_monterey: "7b694c680ff385d4503f29773d982dc57c3ca253699bd818032583fb6efc2389"
    sha256 cellar: :any,                 sonoma:         "ec5c3282ea33d1467ef8b2d26f88db767ed5664afe79929da342cc197cbb3968"
    sha256 cellar: :any,                 ventura:        "f97a8f7428903e26189d4a1e3406039432ea68f6a337917a1d2ee0736a84429c"
    sha256 cellar: :any,                 monterey:       "e16a68e6255f92934297d614cb89a7399a027a095fafb77b780ad75cbf8bfb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3f6051c2def408a13615d7abec7ddb1ae409abb3168adf5a539182d49c9ab7"
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