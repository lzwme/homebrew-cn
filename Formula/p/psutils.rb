class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57da59196fa9222587c17e8027f1c9b83d2506a856b500611b60e2674ce1a07d"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dc/df/a2ee3bbf55f036acb9725b35732e3a785cb06f5c5b9fe47bde8c05ab873a/puremagic-2.0.0.tar.gz"
    sha256 "224fe42b6b3467276a45914e12b5f40905dea0e87963adbe5289667e7c607851"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/fe/b2/335465d6cff28a772ace8a58beb168f125c2e1d8f7a31527da180f4d89a1/pypdf-6.7.2.tar.gz"
    sha256 "82a1a48de500ceea59a52a7d979f5095927ef802e4e4fac25ab862a73468acbb"
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