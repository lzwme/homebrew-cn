class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https:asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https:downloads.sourceforge.netprojectasymptote3.00asymptote-3.00.src.tgz"
  sha256 "c45945ed530abb25b752226afb0be2a1a4a6292ce90029e6cfc5c67a511b731a"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "bfdecf42d170d12d5c1feb127c0b79b0abdbf0807edf978c516a5ab1b26a6e1a"
    sha256 arm64_sonoma:  "eff92539937c51a8ed9eee32385942a64841c9abef29da5cf6b93a247e9f9317"
    sha256 arm64_ventura: "44a698222dfc47ec8be0d35bf713759f01841454446710a49443c01d850cac9c"
    sha256 sonoma:        "d9c366b77a99dfa20d24351a2497e7927ec867c38116fe5fd02ba039dc9762e5"
    sha256 ventura:       "e50632551a67d5d66e40725157ab526ba986cfc5c947c39699bf663f0320be13"
    sha256 x86_64_linux:  "7f3c207da64d586ea1a1f5f7bb9885fa3b8363c75702b07719a90cfde9df22e2"
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
    url "https:downloads.sourceforge.netprojectasymptote3.00asymptote.pdf"
    sha256 "170bbaa5362104364a00728b795df96a7f8d26c48a5a3b21cda67f8307f9ff9b"

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