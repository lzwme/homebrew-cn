class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8a241d42b57f00210238a661f05ed926cd8ad07becbc831ae03e7d37099012b"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dc/df/a2ee3bbf55f036acb9725b35732e3a785cb06f5c5b9fe47bde8c05ab873a/puremagic-2.0.0.tar.gz"
    sha256 "224fe42b6b3467276a45914e12b5f40905dea0e87963adbe5289667e7c607851"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/09/dc/f52deef12797ad58b88e4663f097a343f53b9361338aef6573f135ac302f/pypdf-6.7.4.tar.gz"
    sha256 "9edd1cd47938bb35ec87795f61225fd58a07cfaf0c5699018ae1a47d6f8ab0e3"
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