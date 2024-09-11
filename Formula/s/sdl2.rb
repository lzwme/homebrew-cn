class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https:www.libsdl.org"
  url "https:github.comlibsdl-orgSDLreleasesdownloadrelease-2.30.7SDL2-2.30.7.tar.gz"
  sha256 "2508c80438cd5ff3bbeb8fe36b8f3ce7805018ff30303010b61b03bb83ab9694"
  license "Zlib"

  livecheck do
    url :stable
    regex(release[._-](\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1d2b8c9280a7271aca08ca1ddbc9c1704cf27301167e8273cdaf4100b78af250"
    sha256 cellar: :any,                 arm64_sonoma:   "4e63f83af8ccbf1cd9b261892dcbc588181d5443e7252447bd3db97f9a736ad3"
    sha256 cellar: :any,                 arm64_ventura:  "ecccc1145afb6d7fc19941784454ea5dc019a6bec5e8480d88f754641010d71e"
    sha256 cellar: :any,                 arm64_monterey: "cea3ad61d54f65d6084ad327584cfc1d6c530d2e9170fcc727f495feec4bdbaa"
    sha256 cellar: :any,                 sonoma:         "1730e6eb3cf6ca85ec59e3716f61b9adfc1126ea797990f50ac6c1f57172ecdc"
    sha256 cellar: :any,                 ventura:        "df0dc584b461220af4071c67dc5e311b7bd38105f65c4e90a053731ac4af6ed6"
    sha256 cellar: :any,                 monterey:       "6afd60164b34aed560bba62e0c3a988d7606e074e4b6d3b5cdff95ccba76f4de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c538b4859944edc5341947814a92c381c80f612193f8f7969586d292a4c67f56"
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