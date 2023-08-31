class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/f6/08/3be8ccd5d45d4c0d07d7511948b45d564c892925869ad3e854d6ff15e299/pspdfutils-3.1.2.tar.gz"
  sha256 "51c7f9c9e8f3447242621f1499de8e151bf8e464e6af845be14eef2bd885fd4c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcc24c8f597ddaf4bc08b74612132161808c5c743334c4e4a715ceaea385d24c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc9556d3a42d4e3f61616464559ee950a141e8f4356d61d562fd4617112ecc26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0f89877c10235876f735416027adf1004c9124ebdb3a7816fff2e6c9150666c"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6bc21641cd9302febd11374aca51a9005117672503ba8148d48a447dac964f"
    sha256 cellar: :any_skip_relocation, monterey:       "de338343cea2ea6b2495550095def7e2d918f3f39a82e5c661f18d715e3d255d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5e7f777cfdd4d4b8e7c8ee58d39fbb0a475c89e774cd66bfdc3343b1212b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76b79604ef7aea41fd092fb0342fc983794fab01467d1adc3c8170f725d4111"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/9f/0d/159af7af2a0a14a3b890b0d0e19db267c07888cb0f569c818b30607b9ed7/pypdf-3.15.2.tar.gz"
    sha256 "cdf7d75ebb8901f3352cf9488c5f662c6de9c52e432c429d15cada67ba372fce"
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