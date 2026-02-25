class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.08/asymptote-3.08.src.tgz"
  sha256 "7f2f641e1f8fede4e997d032cb6f88ca3b200f0f1b9f1ab92998387163a196f8"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "09fab4527ab0dcd353195263195bc46e69a4a64cea23decbd2e6983db79907c2"
    sha256 arm64_sequoia: "6c01df74f803bc3e6058d6d72dc8f963f604ae67cbe4d43fcc6b5425d50cbc40"
    sha256 arm64_sonoma:  "b734a898bc7653f6dc65306f2ba7a885c7a631d7ae916f6aef41fab68b1ced50"
    sha256 sonoma:        "8f87baed503376e2e032e99a972aab176fa2a498ca295197a13bd35ba87bcfc0"
    sha256 arm64_linux:   "efd1751463dd421684e826846537c1a5e686f91c8e159f812d86bb9930a7fae4"
    sha256 x86_64_linux:  "368f7410c9dc8abd932a79872862668b982210f04ce60918a319a52b5e686688"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.08/asymptote.pdf"
    sha256 "0772487ab9cf1e9488d7788352fad5ae215b06c34cc14688b7491f2ae2003405"

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
    touch "doc/asy-latex.pdf"
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