class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_8.tar.gz"
  sha256 "159d2156810a6bb240410cd61eb641add85088d9f15c888cdaa37b8681f929ce"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:[._]\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_R", ".r") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fed27805a663a09efa433ef5357e248ffec3c616dc647bb1e34039d888013c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56e1b40c66a5aaef7e82d32e902254f73db4fd48a3e2cf2e845822c188386139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01b1b4ef4dafbdd33262d1d85b7d2170c0fc43b292a71fdd16cc500397717d6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "de41633db5ca8ea97031b485790b2839bd66f9da9e6965e4b2f7133ecd4dd5e1"
    sha256 cellar: :any_skip_relocation, ventura:        "ef39df7ed559a8aa15eec5e7be9df22d1b0ebd989e1c79b4a413c4364dae34eb"
    sha256 cellar: :any_skip_relocation, monterey:       "10cd676f9d46b633a1dc17aa099e33422e5a21cd4aaffc493e35729729e1424d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a439879b6cf21d24797ac4420500a0ecf519a5afa59eb3a7c00fe3900eb4400"
  end

  def install
    system "./configure", "--includedir=#{include}/nauty", *std_configure_args
    system "make", "all", "TLSlibs"
    system "make", "install", "TLSinstall"

    doc.install "nug#{version.major_minor.to_s.tr(".", "")}.pdf", "README", Dir["*.txt"]

    # Ancillary source files listed in README
    pkgshare.install %w[sumlines.c sorttemplates.c bliss2dre.c poptest.c]
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = pipe_output("#{bin}/countg --nedDr -q", shell_output("#{bin}/genrang -r3 114 100"))

    assert_match "92779 graphs generated", out1
    assert_match "100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular", out2

    # test that the library is installed and linkable-against
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty/nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end