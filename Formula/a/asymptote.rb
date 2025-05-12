class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https:asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https:downloads.sourceforge.netprojectasymptote3.03asymptote-3.03.src.tgz"
  sha256 "3c8a4e6988b533d3d58650aa9cbd5566f9f786a9ab0e5fd0a0370f38750e4fbd"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "0f44efa2b77ba2a37e39201dc4e7c5e66a72cad31ce1a084a1f965f216e5631b"
    sha256 arm64_sonoma:  "b86dbae74deda3128abd84da31fc4343407e778379e569d742bde42cb5cbd854"
    sha256 arm64_ventura: "a779939f5a010187830e000e9068ea2c18fed522da98f6750766d01bdd347204"
    sha256 sonoma:        "5822b3bcb86256d00dd3d2b65e6d75df07bcc7e5914df9c287bf8cc259d4de68"
    sha256 ventura:       "7eeba78fa5c23d5485b4d8efa65e79e4b603f5ab415043a88588eaa87c1ce0ba"
    sha256 arm64_linux:   "1f4f6f30d1cd456dc8f0f7d0d9c03662cebf33aea448d162881b806d6881eba6"
    sha256 x86_64_linux:  "4004e2418e853c20a3375db06e1562a0c283a5e6e1f6590a4fcd2258d8cf180d"
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
    url "https:downloads.sourceforge.netprojectasymptote3.03asymptote.pdf"
    sha256 "4ddb5bfee1e00f56e5872130155020cc4372d9bc5a463661547aa08145bbba85"

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