class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://ghfast.top/https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.05.02.tar.gz"
  sha256 "5ab3584870bec378b495242f20f03ecbef2cd032a128ee3394a88ff7a53cd914"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  # We check multiple releases because upstream sometimes creates releases with
  # a `dosbox-x-windows-` tag prefix and we've historically only used releases
  # with the `dosbox-x-` tag prefix. If upstream stops creating `...windows-`
  # releases in the future (or they are versions that are also appropriate for
  # the formula), we can update this to us the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256                               arm64_tahoe:   "b93097b7d97c5d1b260b1c59cca9de3b217f0babe26e1606554a0a4e5d7af1ef"
    sha256                               arm64_sequoia: "71a04385d8976a33ed730dd95555839bda1dfd22487beef288ce17a9248db6b4"
    sha256                               arm64_sonoma:  "bbf0d71bca5601228233c2b7410bf70338131a264ed24a5f02d8eef79ca1c0c1"
    sha256                               sonoma:        "e267b5f70cbd50cb2c46fa18d0f03bfbe843a7754c13cebcf729a6a07e20a2ed"
    sha256                               arm64_linux:   "b550472038030cad19fc72235354143ec65b00c3a197df601d0a97692ee53a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805d703e27fc980a4a9e0595d7ef9039693d3f66d8be2ab54c140030459a465c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on xcode: :build # For metal
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2"
  depends_on "sdl2_net"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    # Set `LDFLAGS` to link against the Metal and QuartzCore frameworks on macOS Ventura and later
    # during ./configure to detect the Metal framework
    ENV.append "LDFLAGS", "-framework Metal -framework QuartzCore" if OS.mac? && MacOS.version >= :ventura

    args = %w[
      --enable-debug=heavy
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end