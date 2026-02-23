class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.07/asymptote-3.07.src.tgz"
  sha256 "e02a9c1b0fdedd5589d5408f08eb13329de6793425a4cb745290510dc98f832d"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0be3384178dc06f22f4dcc80cca1ea2e2969662bf7e6ff7511676c4e72bc0d3d"
    sha256 arm64_sequoia: "5d00ea83f694dc8e83b65a4857e54fcb750aafacdfb38eb185721ce69bf89499"
    sha256 arm64_sonoma:  "64e0c80c40164bd8e88883e54691da11b1615187b8e15438fc5859795bd1bbe3"
    sha256 sonoma:        "325a2acc92fd9a483bf597ad9c1c82852c5d8e66883b8bb0b4c3d16972f04195"
    sha256 arm64_linux:   "ff42820774fbdf9459593aa9f131d01edabfb289c2b020da820e5b9dfb63e768"
    sha256 x86_64_linux:  "4132aa7ca1f2c1191a22a4f55b1fbf9398c56776967429ab4692ef341afd2691"
  end

  depends_on "cmake" => :build
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

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.07/asymptote.pdf"
    sha256 "f5b5c30975eb39462138612ac449902e0cfa8423fe9becf3500f9d2115bfb8ee"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https://github.com/vectorgraphics/asymptote/issues/521#issuecomment-2644549764
    system "make", "install-asy", "GCLIB=#{Formula["bdw-gc"].opt_lib/shared_library("libgc")}"

    doc.install resource("manual")
    elisp.install_symlink pkgshare.glob("*.el")
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_path_exists testpath/"line.pdf"
  end
end