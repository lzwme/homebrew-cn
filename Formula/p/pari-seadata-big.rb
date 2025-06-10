class PariSeadataBig < Formula
  desc "Additional modular polynomial data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/seadata-big.tar"
  # Refer to https://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20170418"
  sha256 "7c4db2624808a5bbd2ba00f8b644a439f0508532efd680a247610fdd5822a5f2"
  license "GPL-2.0-or-later"

  # The only difference in the `livecheck` blocks for pari-* formulae is the
  # package name in the regex and they should otherwise be kept in parity.
  livecheck do
    url :homepage
    regex(%r{>\s*seadata-big\.t[^<]+?</a>(?:[&(.;\s\w]+?(?:\),?|,))?\s*([a-z]+\s+\d{1,2},?\s+\d{4})\D}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("%Y%m%d") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d2610054b7d6eb25f170e25a782db3f92ca8c0b252022b8486765b408b376a7c"
  end

  depends_on "pari"
  depends_on "pari-seadata"

  def install
    (share/"pari/seadata").install Dir["#{buildpath}/seadata/sea*"]
    doc.install "seadata/README.big" => "README"
  end

  test do
    term = "-812742150726123010437180630597083*y^19"
    output = pipe_output(Formula["pari"].opt_bin/"gp -q", "ellmodulareqn(503)").chomp
    assert_match term, output
  end
end