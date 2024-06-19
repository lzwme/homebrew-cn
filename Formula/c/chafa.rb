class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.14.1.tar.xz"
  sha256 "24707f59e544cec85d7a1993854672136b05271f86954248c5d8a42e221f6f25"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c588788736d413d8e1903e09a58f98b862c32ee0b4ca60bed9d5788d8c1bb009"
    sha256 cellar: :any,                 arm64_ventura:  "c5a232a794db05f653064eb1e8563de125059351cfae6846586d66e976775240"
    sha256 cellar: :any,                 arm64_monterey: "8d43efc573ee0370dd42c6000351e18635394f95df772168f59302d9855519ed"
    sha256 cellar: :any,                 sonoma:         "72efc9066f140136c6cb187c9a530687d2dedfb8b9fc75610c34a562c9d6f6ae"
    sha256 cellar: :any,                 ventura:        "cf3cd86afd9f30364cc63b8e4da901d595b97175cb0e76af9f32e765a0ce7d10"
    sha256 cellar: :any,                 monterey:       "de19352d7a7f30293af8bcdd0f124868dfb63bad99b4fef1a2315d67faebd582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d04fa0a10c7e5dd6a7347638817bafe4a29762b372006c3be00c3ed0ba78e67"
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
                          "--disable-silent-rules"
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* JPEG.* SVG.* TIFF.* WebP/, output)
  end
end