class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/d3/d9/033d800f92c3d89aa93b5ebf35991599d91005fc2e9ed69b22b149d52432/psutils-3.3.16.tar.gz"
  sha256 "d259da9bc95395fe9761b289333e83866ecbf2d43ee844e74a14a3f74ff2808b"
  license "GPL-3.0-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7eb55116ab314fbfc73c84accd7876eeab4e21154f8da49789030a8cd0961e7f"
  end

  depends_on "libpaper"
  depends_on "python@3.14"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/44/66/54212e75406afd9f3e933d0dda23072f6aecc55c5a273077dc2e0b028b23/pypdf-6.16.2.tar.gz"
    sha256 "595647f6191de6f402cfde1d0c455d6cbccbd509aac32b34783009c032de5d6e"
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