class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https:www.gnu.orgsoftwarerecutils"
  url "https:ftp.gnu.orggnurecutilsrecutils-1.9.tar.gz"
  mirror "https:ftpmirror.gnu.orggnurecutilsrecutils-1.9.tar.gz"
  sha256 "6301592b0020c14b456757ef5d434d49f6027b8e5f3a499d13362f205c486e0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6556b10f353cbae8cc5d69cc48cb0662eaf85060794e0d29ae25950dbe02749e"
    sha256 cellar: :any, arm64_monterey: "09a875626acf4c73036fc8048bf3e0e5bb7beff7fd60e1e96faa1b1d92888638"
    sha256 cellar: :any, arm64_big_sur:  "c2da94eb14db7fdd4f6376cd3d6546ff8cebddd64f4290fe265161f21d3fdff8"
    sha256 cellar: :any, ventura:        "50252c2587e2e32f0513c9cc71fd49c5786400f6c0d6e95891da4b43a0f873fa"
    sha256 cellar: :any, monterey:       "feac0920394addceefb8a23fc38a7406fed04b71bde433d14dfa703b852c5089"
    sha256 cellar: :any, big_sur:        "8bd10813a8870b76fdac43c99062d3449bd4275ae54af0410c85c69ba3f9ab08"
    sha256 cellar: :any, catalina:       "d92195d721c086a0f14fa0dcdd8014869af600d43e31749a8b8af580f49fafba"
    sha256               x86_64_linux:   "09224d89dd80efca59a618cb2b966ad1a2a1847d992bc27c014fe997db0148af"
  end

  on_linux do
    depends_on "libgcrypt"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    system bin"csv2rec", "test.csv"

    (testpath"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system bin"recsel", "test.rec"
  end
end