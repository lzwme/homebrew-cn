class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://ghfast.top/https://github.com/gpac/gpac/archive/refs/tags/v26.02.0.tar.gz"
  sha256 "7a265e1cd58b317d8c9175816a54e0ab14199c21d81eb779047d7088fca52ae4"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b827c215c8b7d1e7d108a34a6d2f8bd127da04b548a61f58379df1a066451592"
    sha256 cellar: :any,                 arm64_sequoia: "fd8a3461b048e0e74aa7165f98bef3cd86e0a018a13110a85bb14b42a97d0df2"
    sha256 cellar: :any,                 arm64_sonoma:  "b318337422c173c1c98c1b3016e4a9dd7b35267841ec95a579e73415ef64fd62"
    sha256                               sonoma:        "8d43d2cadf89faced475a4c5250a663fe506d7effa103729da19504fab3bb7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bffae0554449c599a0b421f086e78c241acf5a7370171f559199ce06a42c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614c831f53a857cb73e09a384a97c2436185c79b07824aff604a3caee548ae8f"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libnghttp2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "theora"
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
    depends_on "pulseaudio"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"MP4Box", "-add", test_fixtures("test.mp3"), testpath/"mp4box.mp4"
    assert_path_exists testpath/"mp4box.mp4"

    system bin/"gpac", "-i", test_fixtures("test.mp3"), "-o", testpath/"gpac.mp4"
    assert_path_exists testpath/"gpac.mp4"

    assert_match "ft_font", shell_output("#{bin}/gpac -h modules")
  end
end