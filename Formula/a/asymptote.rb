class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https:asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https:downloads.sourceforge.netprojectasymptote3.01asymptote-3.01.src.tgz"
  sha256 "7a05000ac3f6bf0631daebd2099f07fe32d4f5fd7b4a2cfc8055b008d497b084"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "9e31ee502188a1fd16053b869888bc385e20c1509a35c744c3ede06d82cc8e60"
    sha256 arm64_sonoma:  "f2d69db601de32e45e848cb3683e5a3f74cb5bd4cf5b11087cab352308f41edd"
    sha256 arm64_ventura: "679785fc2b2b9bcc8f88b954f2135b392191913cc454a8b29336bffac8f4e236"
    sha256 sonoma:        "c66197c421a4c45d521a56afce6ac4c322f6256f232267816598ae6c5aecd9df"
    sha256 ventura:       "ff73c501bc220577f13d4f4cf2c407fb0f3b3faac7b08a7a5117bf50c1090f9a"
    sha256 arm64_linux:   "6a37f9ce6e689eac8a96c4eeea3c66d259a253fa07e850aad1532dd489da556a"
    sha256 x86_64_linux:  "2fc5cb3f09f0ed19aecbd59d308fb499bc25fff4c056783670acb184590bb3a1"
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
    url "https:downloads.sourceforge.netprojectasymptote3.01asymptote.pdf"
    sha256 "4e7ba61b6d65c41827cd73fe177fc24a6992b0a93aa7be77bbd6a16240962669"

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