class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https:asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https:downloads.sourceforge.netprojectasymptote2.98asymptote-2.98.src.tgz"
  sha256 "c50239cabc33ce7e8ef843d249c552e309caff9eba937d829e3a2af68385da91"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "bdafe69326937771b01ed9921c14d805c09e83a4c1752a5b0caa36d466d039ea"
    sha256 arm64_sonoma:  "be9dbe258bd259eac4f8188b91c4c8f39272f47046148e2c31081cb615e75956"
    sha256 arm64_ventura: "8382960786105dd7895a67916a6d47d832db85dbde2ebfcf9df496522ba071c7"
    sha256 sonoma:        "f515a38edb13f9c1b4877317136af2bacf3895459f87f08dcabfb78c91c35b63"
    sha256 ventura:       "431b379967397b9dd5a53726e322f1cc764214078da200e882d2bb0af665aa27"
    sha256 x86_64_linux:  "62f94d1dbce0bf603bae1f120eb6bb5760b9000c037fda6cd88422f09c57b100"
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https:downloads.sourceforge.netprojectasymptote2.98asymptote.pdf"
    sha256 "c1d16d966f6206676c720c54c273ff3ec80d3615aafccdee892b0b048143a491"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system ".configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https:github.comvectorgraphicsasymptoteissues521#issuecomment-2644549764
    system "make", "install-asy", "GCLIB=#{Formula["bdw-gc"].opt_libshared_library("libgc")}"

    doc.install resource("manual")
    elisp.install_symlink pkgshare.glob("*.el")
  end

  test do
    (testpath"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin"asy", testpath"line.asy"
    assert_path_exists testpath"line.pdf"
  end
end