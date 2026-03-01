class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/gnu/groff/groff-1.24.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.24.0.tar.gz"
  sha256 "e79bbcd8ff3ed0200e7ac55d3962a15e118c1229990213025f2fc8b264727570"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "d34671fa2f154cc98602dbc51a93b5fdfc632fd96def3585697b0b3ee8c293a4"
    sha256 arm64_sequoia: "8ef7feea44490be0ddb616d9eebe2936f3d6185ebeb4593fe9e512c7ff60ad4f"
    sha256 arm64_sonoma:  "76831383bb07478c8f3343ab89f42df65f6355ca584e65557bf7970634f1f62a"
    sha256 sonoma:        "14faebaf892fc993f9535e97fdacf54e23cbc2c4e413119b5373cc2dca4e0c9d"
    sha256 arm64_linux:   "8a470dc142b6cc08ea1ed94945816516b68ecde8c628731a7097a02d080b1243"
    sha256 x86_64_linux:  "a881f10b610f95233a09e7154bd1b0e719e8a62b4379b11496ff23b733502f6d"
  end

  depends_on "pkgconf" => :build
  depends_on "ghostscript"
  depends_on "netpbm"
  depends_on "psutils"
  depends_on "uchardet"

  uses_from_macos "bison" => :build
  uses_from_macos "perl"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "glib"
  end

  def install
    # Local config needs to survive upgrades
    inreplace "Makefile.in" do |s|
      s.change_make_var! "localfontdir", "@sysconfdir@/groff/site-font"
      s.change_make_var! "localtmacdir", "@sysconfdir@/groff/site-tmac"
    end
    system "./configure", "--sysconfdir=#{etc}",
                          "--without-x",
                          "--with-uchardet",
                          *std_configure_args
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n", pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end