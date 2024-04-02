class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38b492f9ec33092f51b1bb6bad26e2f1840129dbf9a1eab2739378e9355f82ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daefe4bf578f653e750eb11b100074f65c651ad4be9bfaeee19d4fa6bd446acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "866221e79bf9cde0b0ba084ee01497fe5fe74e4375e0318d489700d049aa1518"
    sha256 cellar: :any_skip_relocation, sonoma:         "76a9872388088a31312406840e0871281075e3a1233f4602157e4bec6b9a4168"
    sha256 cellar: :any_skip_relocation, ventura:        "4c2307ea3a65757e26371bcaa981625b4b589698e6b8e03de66484420a568354"
    sha256 cellar: :any_skip_relocation, monterey:       "fe924f4fc1c4efa81e2286076c693020a9f216caeb31f455607b4675d4e783dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf110d232748b58ac8ce626a5738ec49a2ae9bdcc96f2c014317b7faa47adaf"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end