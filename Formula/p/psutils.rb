class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 8

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61e57f4a4e83f06768c9c2930e9f7027a6ec37ccb36f8ca41dc571a220cd3457"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dc/df/a2ee3bbf55f036acb9725b35732e3a785cb06f5c5b9fe47bde8c05ab873a/puremagic-2.0.0.tar.gz"
    sha256 "224fe42b6b3467276a45914e12b5f40905dea0e87963adbe5289667e7c607851"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/f6/52/37cc0aa9e9d1bf7729a737a0d83f8b3f851c8eb137373d9f71eafb0a3405/pypdf-6.7.5.tar.gz"
    sha256 "40bb2e2e872078655f12b9b89e2f900888bb505e88a82150b64f9f34fa25651d"
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