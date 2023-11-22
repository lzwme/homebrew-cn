class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_8.tar.gz"
  sha256 "accf5eeddde623d179c8fee9d15cfb7d66d7a90cc7684d11c96ad9b3f3655dbb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc17c5700166b0e9e5c17bb7454c2eddbe108e4b04863af6d5e0bdd89a75bc38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6432a71064390f2afa50d16ffa26b8fe907c2ef3a2cd0c8f5d7696c3953352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f368b7a5e5d259c01226c1e95ca0eb53bc13549b4286db953a9f25220ae8fed6"
    sha256 cellar: :any_skip_relocation, sonoma:         "915f0ee5a28c9b40707d590b5051982c2df808405c1b9f27b919ff819850acf3"
    sha256 cellar: :any_skip_relocation, ventura:        "b26562027d60564b34b4e27a987869f51e974c5903218e39d50fb23f163c0d98"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbfbb5e238919a56a2a7ba900c061c509f1f184af78059b929b8494adc058fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1571908d43d478112477c4e47a0bf17ae88851b5922c606dc2aa72e88f62b78d"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install %w[
      NRswitchg addedgeg addptg amtog ancestorg assembleg biplabg catg complg
      converseg copyg countg cubhamg deledgeg delptg dimacs2g directg dreadnaut
      dretodot dretog edgetransg genbg genbgL geng gengL genposetg genquarticg
      genrang genspecialg gentourng gentreeg hamheuristic labelg linegraphg
      listg multig nbrhoodg newedgeg pickg planarg productg ranlabg shortg
      showg subdivideg twohamg underlyingg vcolg watercluster2
    ]

    (include/"nauty").install Dir["*.h"]

    lib.install "nauty.a" => "libnauty.a"

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
      #include <nauty.h>

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