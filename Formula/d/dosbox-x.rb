class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https:dosbox-x.com"
  url "https:github.comjoncampbell123dosbox-xarchiverefstagsdosbox-x-v2024.12.04.tar.gz"
  sha256 "f2bca4c2c8da69085c0eabfb60886b67e3ad55b21974d4e1c3c79a2d3756add3"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https:github.comjoncampbell123dosbox-x.git", branch: "master"

  # We check multiple releases because upstream sometimes creates releases with
  # a `dosbox-x-windows-` tag prefix and we've historically only used releases
  # with the `dosbox-x-` tag prefix. If upstream stops creating `...windows-`
  # releases in the future (or they are versions that are also appropriate for
  # the formula), we can update this to us the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(^dosbox-x[._-]v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_sequoia: "59467b8723e04efbb5620d5fdaa12e318c876db24e8ef485a72389237bfe22e6"
    sha256 arm64_sonoma:  "3573aa8da811f6e9144a7b3435b757470fbd646a0a9c16c8e829406ebfa71cf9"
    sha256 arm64_ventura: "3aa4b10af3c994b0bdd325fb1c3e3c601183185df5ca1762367642014cfa5bac"
    sha256 sonoma:        "77cdea7889af7e5c7007475d468062d5d11c71f11c77eb2cc97f3a59d97a5b4a"
    sha256 ventura:       "0f949ea6c25adfa4497825fc2bf012e02952a9f947918bbf2df1264e1ff60796"
    sha256 x86_64_linux:  "78106f53a4c75a39a50ea109a93fe439a65248bd1280e996e53c2308940b371b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on macos: :high_sierra # needs futimens
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
  end

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-debug=heavy
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system ".autogen.sh"
    system ".configure", *args, *std_configure_args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}dosbox-x -version 2>&1", 1)
  end
end