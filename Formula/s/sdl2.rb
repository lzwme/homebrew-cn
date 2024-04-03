class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.2SDL2-2.30.2.tar.gz"
  sha256 "891d66ac8cae51361d3229e3336ebec1c407a8a2a063b61df14f5fdf3ab5ac31"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "445aa245cc3bb0d89872de6d66cf6a46c9b4a47a3f2012a0010c0604fa299abc"
    sha256 cellar: :any,                 arm64_ventura:  "9218fb08abb51f41ca10537f85eecae21d7c97692106665e0a2f1304fb22691d"
    sha256 cellar: :any,                 arm64_monterey: "80489b9816c6239c3adfa8773c0b56d9bedd58b976a785f481158460b8590189"
    sha256 cellar: :any,                 sonoma:         "360557c1efae12479cfbe1c5ede148ae1607c0fc1a2f618c59a548ba38017c4f"
    sha256 cellar: :any,                 ventura:        "cdeae7e7b5a9f2304b52036cda8e09f072c578b48dc9e795da6622ca0d38049a"
    sha256 cellar: :any,                 monterey:       "e4df8bd5434b58afdcf7b3a4e3b88caf83c59d9734c12ce2cb3e13bc96e52824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80c464498e354a3fc386a78c80f8b421b0c75454f7f3f113d078f66ac0487f86"
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