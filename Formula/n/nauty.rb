class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_9_0.tar.gz"
  mirror "https://users.cecs.anu.edu.au/~bdm/nauty/nauty2_9_0.tar.gz"
  sha256 "7b38834c7cefe17d25e05eef1ef3882fa9cd1933f582b9eb9de7477411956053"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:[._]\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_R", ".r") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfd808185ff5ca8b384dd1e7595a4c663ea60dfc2d9753a0b7b9e89e58468de0"
    sha256 cellar: :any,                 arm64_sonoma:  "fe36b481ad6fd48ccb984c2b6490f589ab752dc9533b7df2e607c69badaac5d0"
    sha256 cellar: :any,                 arm64_ventura: "e8e7503b16e1f881eb8c5d79afccdd8f8d29f6f8e6d5e8e864ea5ad00e2c062d"
    sha256 cellar: :any,                 sonoma:        "503471db07b08a390c6b976a207caba8491d4172e95cc5f487be5e1681421a22"
    sha256 cellar: :any,                 ventura:       "dac0d277931c08200e75f57a423974cdfb129f8641bc38e82fdf737c9867b088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ffc0831b4883e02ab3dc8b32ff79492a2044b3ab2bf4cef4f49fb22cdae007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cbaedd6109b9d51d5e96830b8a2e8d925b0914cc7d66490102bd588ddc6c0b3"
  end

  def install
    system "./configure", "--enable-tls", "--includedir=#{include}/nauty", *std_configure_args
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
    (testpath/"test.c").write <<~C
      #define MAXN 1000
      #include <nauty/nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end