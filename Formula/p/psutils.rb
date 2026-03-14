class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/45/ff/4af412351a21ee38835b7597555936c547830d9a8246a2b7d2aa41aabdd3/psutils-3.3.14.tar.gz"
  sha256 "6212167dd8c09f59c9535d5e416c4f8c01431b7a5beab0ee68f4ec416ca3980c"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, all: "425513bb7585ae987b595ef7eb6b4fc52c40e6c3be2e689aac68b07908171c7b"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/02/3b/0fe979ea1e2768758259f4d412b8cb26d9418e82d5fd10fdf7f00dc70e15/puremagic-2.0.2.tar.gz"
    sha256 "3ebc28f9380e19dbd8179aeaa08e9692334d71194fc6e5865818770d2bee44c8"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/b4/a3/e705b0805212b663a4c27b861c8a603dba0f8b4bb281f96f8e746576a50d/pypdf-6.8.0.tar.gz"
    sha256 "cb7eaeaa4133ce76f762184069a854e03f4d9a08568f0e0623f7ea810407833b"
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