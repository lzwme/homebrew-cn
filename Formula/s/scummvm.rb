class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.1.0/scummvm-2026.1.0.tar.xz"
  sha256 "e15b8650c2bd9e11b69b49eef9dea1eedccc5b1c191748b15c34167614d77b66"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ccfd9caf1bad9cc2fb4f185708f9059d4edb10df44f7b37a925aebd152743ad9"
    sha256 arm64_sequoia: "97b75edbe0676df112394066a2242151d9ca17b60fdd7959afc8a52fa6fe7bcb"
    sha256 arm64_sonoma:  "c01f5c9d27412bfc2fd5ee5693c6e1d6be794fcc736e8082fd8f9e092a346fca"
    sha256 sonoma:        "2cf0d7b5a425ae4cb19e0750444ddd2d457edea92cd56c302517a342c9948b17"
    sha256 arm64_linux:   "1ef85a22c97e98bfcbf12f0f344c65dbc9068533be44875ab20523a0485a7804"
    sha256 x86_64_linux:  "8ebf87962c1701bd2344c717a6d1a0637f896111ee2e54ec78e59e6b3cec7f1d"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end