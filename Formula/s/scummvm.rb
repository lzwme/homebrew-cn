class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https:www.scummvm.org"
  url "https:downloads.scummvm.orgfrsscummvm2.9.0scummvm-2.9.0.tar.xz"
  sha256 "d5b33532bd70d247f09127719c670b4b935810f53ebb6b7b6eafacaa5da99452"
  license "GPL-3.0-or-later"
  head "https:github.comscummvmscummvm.git", branch: "master"

  livecheck do
    url "https:www.scummvm.orgdownloads"
    regex(href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "b3f50a224cb7565d6a9e484d060d536c960926fa75ede22414559b4b2ed26080"
    sha256 arm64_sonoma:  "b79272444016cef3bdf08caee3c706499697f2e2f957d8cdd831035d9695deac"
    sha256 arm64_ventura: "8f6610ad1589f173888bfb5003c3b7231383a10be5a668fc0836e92521f1cd27"
    sha256 sonoma:        "ca9da658a16b599603785e83ac0cbbb3885b8cdd7633e1bc2c8b04f1bfaf1bb2"
    sha256 ventura:       "8dd1d46ce87231f8462293cbb0b3d0a3f8dbf91c44c59f59311c5d2fe43f9f50"
    sha256 x86_64_linux:  "0c859bc01c0943c6a91a835071ddaf5cc97dda381d37c592b4acdff8935410c9"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmikmod"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system ".configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share"pixmaps")
    rm_r(share"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin"scummvm", "-v"
  end
end