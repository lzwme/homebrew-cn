class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.06/asymptote-3.06.src.tgz"
  sha256 "5cc861968fe8102fc5564b6075db2837dd5698672688b3bfb71406c0da0f8cef"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "9d9498abe8b72b1c827fb77a1eb52b82aefdb838aface4c65c76932c55553683"
    sha256 arm64_sequoia: "7422cc8b780791a5666e0a19b97407ff99728bc14359d25988377438ff191d77"
    sha256 arm64_sonoma:  "edc628f47893250645defd2f2cc0b1df20c0dfdb5f3259ac269baa181e6e6ed6"
    sha256 sonoma:        "2a430a3b0d192124662bf6677fc1c4a782bff6f0ef16b155f40e474ee3d07766"
    sha256 arm64_linux:   "bb0a18317d3e0b1576bd267e5513b48abf485063c7384c60c4382aafaea76efa"
    sha256 x86_64_linux:  "2440d5d584daef22c7b5c01fe9e64351925f08a27fcb3168e68c8767cd71abf5"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.06/asymptote.pdf"
    sha256 "dfcbd9f300a4bb9ef21ab5ad150fd22dbaeacbe1d710f1ae0288a971ffbdd9e8"

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