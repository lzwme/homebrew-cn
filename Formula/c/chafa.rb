class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.16.0.tar.xz"
  sha256 "bf863e57b6200b696bde1742aa95d7feb8cd23b9df1e91e91859b2b1e54fd290"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49697b8db7bd95a873f712be4ff25880fed05ae190fdde439626df6eb81bfefb"
    sha256 cellar: :any,                 arm64_sonoma:  "fa07587c91aa2541f5e2bb57d00864e41e8536a5e6344fada7013e16897fa9dd"
    sha256 cellar: :any,                 arm64_ventura: "e2a2bcec2e167c43696dd69614301a65708a17c81b93397be8707200a090336b"
    sha256 cellar: :any,                 sonoma:        "df3a6eb954c9e7f34ccbd8b15d2ac6f982c88713a3e74f08e5093de4f4d69fcc"
    sha256 cellar: :any,                 ventura:       "50d16fdfa1670e476b0ddf2c6d1263ee0ed96129ffbb4c80181b2c67ad6c2183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9524b6ae316553be67312b647dc17f7cba168b1752a6c328a9087de6e1480bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cfbe79a8074c66a5fc235d39edd1b716d4f80c28d6ce27d7b4c6aab02e6839c"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end