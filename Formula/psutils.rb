class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/c9/e1/b21d2005f929ee9a8891080dbff70b322566e027e16823a050e72a37baea/pspdfutils-3.0.8.tar.gz"
  sha256 "392392b7eb67848a7f30e7c96e88e0a54bdc95b34dea57df6f3fad303289e40d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fda002b8a0c20fa5e4626e827c295d8ef1a1b3d14dcad54a0f771a7ed1ec42a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb3fcb513f91e43ea235709ed6e810ebf9ffc6ce2ecd49998949316072a095a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bdc65dacd48ea06333777afc31bd26e8223826b523ef503d14ef72b3d0c890d"
    sha256 cellar: :any_skip_relocation, ventura:        "7d448efcb5ead1f64dfaa7472cb42347226a7fd4b8c5ff297694e1b12540e782"
    sha256 cellar: :any_skip_relocation, monterey:       "63d2c96491c3b6235dd5e3ed92cab8eb83b7a4608f64e9859330cd4ca55a63b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "739d90c1726474b4f1086dcf73d299ebf1fd5e83c6d6a31e35697bdc2fd8fabc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d065f7b55f00efce836ded40c1935655a1568c55f1148a50b88fba1a27fdcbb3"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/54/34/0f351758d7285409cc7ec7f7b92cb5201416bf7bfb78461ee1a593e75c74/pypdf-3.12.2.tar.gz"
    sha256 "8657d56fd4f64540b9a1e5285845543534321484f1276af893eead7bd00598e6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://ghproxy.com/https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
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