class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/92/07/ebcf289c31f4da85ea94e103f0a58393c54133c64fcbef754c17b6405723/pspdfutils-3.3.2.tar.gz"
  sha256 "a20a2a1359811bd0ad72e15349351a26774ddf8e355c2cde4250a70cf77fdf0c"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bdc4453807c4ed3b080777b885e659276cc38fa010ea9285e1416333df88766"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1871b1b0e7a67f4bbc8566748726d99788dec7eb38b21cc9786b9f96b2757c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a85e130e4b7d78bd19412bc07253f9de211c3f38bf99e9c9354be247dc5617"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f31f997bc29be3b8d527f2be7bc1ade95c0c569f4ba7f390a7b86b222e73494"
    sha256 cellar: :any_skip_relocation, ventura:        "52fb31fd98fc9064ce67791855a0115e4bc28a1eadc273e2f157fe8aea5d1934"
    sha256 cellar: :any_skip_relocation, monterey:       "67cd662a7d69f556d04b9f62f0a38a6a0ea933b6907b3b5007188ef4112a6f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29d669346ddec8212ac20c56905df4df2e7e2b5715331c9e184fc1ab65ef2ed"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/53/16/81e2f71268566c6c6f57f8a5fbb36e198cd4ba6e55ba39a36af48ce75520/pypdf-3.16.4.tar.gz"
    sha256 "01927771b562d4ba84939ef95b393f0179166da786c5db710d07f807c52f480d"
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