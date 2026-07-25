class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/78/50/adfefdc3096c2c25a135ca8e4f2485c891bc6bb60b86d27f3955af65b5c4/psutils-3.3.15.tar.gz"
  sha256 "7001ff39c5a84e2616aecbe8c9d213f14412908990f84dfbd92168edfdbaaf3d"
  license "GPL-3.0-or-later"
  revision 3
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7750f019359055538bc20c12dd750da3c5739120cc268a2b5cbfb9a2c774507"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/03/72/7dfd5ff1c9c37de97a731701f51af091325f123d9d4270361c9c69e4431f/pypdf-6.14.2.tar.gz"
    sha256 "7873f502fe4385e79539b21d872392dc0c4e3714327c15881cbc7fbfd1f95b25"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://ghfast.top/https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end