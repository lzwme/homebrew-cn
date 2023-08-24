class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/51/e1/84b207ea1ac7140a626988f6cb46e1ad30c46996715ab8940fbc079461ba/pspdfutils-3.1.1.tar.gz"
  sha256 "86f9c769b6b1a76ddda64fe0d28694545de0397aafa318dc2cae809037569018"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c38784211c1569321112898e664a4a2920e6e9649fbd6ba95c46411557300f77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f09a916da6ce5db248c61e2637dbea95b3c65629d2dd585f69ece873b83f9c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b9fa8d5aae00e1d50101798493294b1b1daeadba1a024cb7c19f49ad4c4a170"
    sha256 cellar: :any_skip_relocation, ventura:        "a55f8c350eee88aa2432d7bded1b4dfd047d06d4145c3763eb009f3695fe43e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f17642b91fe75efb9231bba8dbc1436bc05a19376ef783e1f8e0492771d22acb"
    sha256 cellar: :any_skip_relocation, big_sur:        "dff3f9d017d79e30b9fc61c3a06f31bae4fdcbaaef8d30a16377b3520e81fec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f432ce3de0826a406f5e6a543d84f288da255a8651f9de89a961606a1257fb"
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