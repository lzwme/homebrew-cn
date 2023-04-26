class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.4.tar.xz"
  sha256 "9774bd1a7076ea3124f7fea811e371d0e1da2e76b7ac06260d63a86c7b1a573f"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea7a26e8eb91d7d9df8adca574bba34e487253a8ab80f8c4f68a3dec13a2e7bd"
    sha256 cellar: :any,                 arm64_monterey: "c431e140340f2b98a3efe52474b5d3bc9c229c8ead2a436df201aec1d5f32be7"
    sha256 cellar: :any,                 arm64_big_sur:  "dc464c972fb2537e833d384006d2501842a40d3660bb6054ac228ac37a0803dd"
    sha256 cellar: :any,                 ventura:        "09a91d03866c38c45c76952013da6c9c1db02aba44d13a24e6d5bc1e932e4ae9"
    sha256 cellar: :any,                 monterey:       "e510c5744c6ff737f8ea3058a45a13f8daed93a70a0cb36b2c9c0a0e2f4408ec"
    sha256 cellar: :any,                 big_sur:        "97f03aacd9275ee795f9669b2b35027961a2c87c91d0a92507b107fefc3ec8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba26ec5846fd0779786c2049d70fc57ba4b3836d83e289abc8210001269a2626"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-imagemagick" # deprecated in 1.12.0 and planned for removal
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 2, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end