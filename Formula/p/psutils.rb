class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https:github.comrrthomaspsutils"
  url "https:files.pythonhosted.orgpackages345a798bf4f061094e6a526b66cf020488440c2816d2aa176218918d7723785apspdfutils-3.3.3.tar.gz"
  sha256 "5403ea98d5131b01c541f22cac04af744a45a4658912e9f7db793fe95b5e6e9c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, ventura:        "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, monterey:       "9b062498b921ed5d177d2e454878a74586a3e3593e2b0e9dcf1548f1673d5250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8222ae4056fc22b3edb996f0a517516dad196d4b825b100e5ec1becf4f05d3f"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesb86ec8fde967ef33df3740a0af9340bdd5d77af422bb10e7abb4c56977e61907puremagic-1.26.tar.gz"
    sha256 "ea875d3fdd6a29134bdd035cdfeca177fed575b6bdd68acd86f83ca284edc027"
  end

  resource "pypdf" do
    url "https:files.pythonhosted.orgpackages71012b94d9be4ae36f30e7f980db2f05c9b92831cea87b96669d528d07f44badpypdf-4.2.0.tar.gz"
    sha256 "fe63f3f7d1dcda1c9374421a94c1bba6c6f8c4a62173a59b64ffd52058f846b1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https:raw.githubusercontent.comrrthomaspsutilse00061c21e114d80fbd5073a4509164f3799cc24teststest-filespsbook3expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}psselect -p1 expected.ps test2.ps 2>&1")
  end
end