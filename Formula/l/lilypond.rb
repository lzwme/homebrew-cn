class Lilypond < Formula
  desc "Music engraving system"
  homepage "https://lilypond.org"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-only",
    "OFL-1.1-RFN",
    "GFDL-1.3-no-invariants-or-later",
    :public_domain,
    "MIT",
    "AGPL-3.0-only",
    "LPPL-1.3c",
  ]

  stable do
    url "https://lilypond.org/download/sources/v2.24/lilypond-2.24.2.tar.gz"
    sha256 "7944e610d7b4f1de4c71ccfe1fbdd3201f54fac54561bdcd048914f8dbb60a48"

    # Fix for ghostscript 10.02.1
    # Remove with next release
    # https://gitlab.com/lilypond/lilypond/-/issues/6675
    patch do
      url "https://gitlab.com/lilypond/lilypond/-/commit/179b9f6975b6a3ebfba043bc953ae95fc4254094.diff"
      sha256 "e95c6b4c03f36f18b4a35e974494c3ae2bd676a76ef9393fd655c7a14aee93eb"
    end
  end

  livecheck do
    url "https://lilypond.org/source.html"
    regex(/href=.*?lilypond[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "0442b5c7158b829291e20c90672adc24ea00964ef2f8577a8ee0104a471efc70"
    sha256 arm64_ventura:  "4967d893a610d6f707d6d3fc08fa21b655dfa957b490740a81c48a95930bf439"
    sha256 arm64_monterey: "b734bad08cca226854d3f0146ed2ea123ee161af694dea74701c420464e7d8a6"
    sha256 sonoma:         "4de5241965b6b596c7bfd5fc587619c88530ee1b67eceb448c609518381f96de"
    sha256 ventura:        "667efe3b3a15fb500d225acd48a8161eb2b9878d3fce9354ab876b04df3d4bc9"
    sha256 monterey:       "c00abbebb54b00416e1a8a12abf86185a8354dc348190764854b44eb38db3a61"
    sha256 x86_64_linux:   "ed65afcb03b0aced7730dd0f2f91ca916ab6858105e0fa59e4def90a22aa07e1"
  end

  head do
    url "https://gitlab.com/lilypond/lilypond.git", branch: "master"
    mirror "https://github.com/lilypond/lilypond.git"
    mirror "https://git.savannah.gnu.org/git/lilypond.git"

    depends_on "autoconf" => :build
  end

  depends_on "bison" => :build # bison >= 2.4.1 is required
  depends_on "fontforge" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "t1utils" => :build
  depends_on "texinfo" => :build # makeinfo >= 6.1 is required
  depends_on "texlive" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "guile"
  depends_on "pango"
  depends_on "python@3.11"

  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build

  resource "font-urw-base35" do
    url "https://ghproxy.com/https://github.com/ArtifexSoftware/urw-base35-fonts/archive/refs/tags/20200910.tar.gz"
    sha256 "e0d9b7f11885fdfdc4987f06b2aa0565ad2a4af52b22e5ebf79e1a98abd0ae2f"
  end

  def install
    system "./autogen.sh", "--noconfigure" if build.head?

    system "./configure", "--datadir=#{share}",
                          "--disable-documentation",
                          *("--with-flexlexer-dir=#{Formula["flex"].include}" if OS.linux?),
                          "GUILE_FLAVOR=guile-3.0",
                          *std_configure_args

    system "make"
    system "make", "install"

    system "make", "bytecode"
    system "make", "install-bytecode"

    elisp.install share.glob("emacs/site-lisp/*.el")

    fonts = pkgshare/version/"fonts/otf"

    resource("font-urw-base35").stage do
      ["C059", "NimbusMonoPS", "NimbusSans"].each do |name|
        Dir["fonts/#{name}-*.otf"].each do |font|
          fonts.install font
        end
      end
    end

    ["cursor", "heros", "schola"].each do |name|
      cp Dir[Formula["texlive"].share/"texmf-dist/fonts/opentype/public/tex-gyre/texgyre#{name}-*.otf"], fonts
    end
  end

  test do
    (testpath/"test.ly").write "\\relative { c' d e f g a b c }"
    system bin/"lilypond", "--loglevel=ERROR", "test.ly"
    assert_predicate testpath/"test.pdf", :exist?

    output = shell_output("#{bin}/lilypond --define-default=show-available-fonts 2>&1")
    output = output.encode("UTF-8", invalid: :replace, replace: "\ufffd")
    common_styles = ["Regular", "Bold", "Italic", "Bold Italic"]
    {
      "C059"            => ["Roman", *common_styles[1..]],
      "Nimbus Mono PS"  => common_styles,
      "Nimbus Sans"     => common_styles,
      "TeX Gyre Cursor" => common_styles,
      "TeX Gyre Heros"  => common_styles,
      "TeX Gyre Schola" => common_styles,
    }.each do |family, styles|
      styles.each do |style|
        assert_match(/^\s*#{family}:style=#{style}$/, output)
      end
    end
  end
end