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
    sha256 arm64_tahoe:   "9b8b41e00303a44fab6074eeac13ef183c6cf3fc167cc934e705dce5c1e94bbe"
    sha256 arm64_sequoia: "2825c53a1f67cccede84c19113d28a0612740bfc4b88c65d7633c42d86568669"
    sha256 arm64_sonoma:  "35897da6949b78259eaf3da7c588bc6285446edd75793fd369511c73c753106c"
    sha256 sonoma:        "a5195517e33e764df64776544cbfbc820b789cf96e082b8bb3b83f2c72bd2413"
    sha256 arm64_linux:   "1297386d01e756231a59fa06d3f669524dfee8311a40b5772fc479ecf646ec14"
    sha256 x86_64_linux:  "659126a0d7cdb853b58356323b348f42a219fff87df3dc259d2b04bef0a9921a"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
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