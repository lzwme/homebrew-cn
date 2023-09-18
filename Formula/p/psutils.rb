class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/df/de/ce4339642a35e20c163a1f835c326819a926fe8d82711206156629d74cff/pspdfutils-3.3.1.tar.gz"
  sha256 "503e5469061fc6fb04ed19bddeb995b8320037417c8fc3fd2c46860c98593009"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19fbb2f4b8145c12cdf89f69d3de7e91ca3c8f6f1abb78367abc726d966434ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba13dace7298e93eee80e8d71574ca9c478f9e98290804930f0a4a9ad9c7f731"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "500d037b9d38ba151aae6cc03f256e319fd5ecccf81a14400c397dcf5aecc0b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c48cba5470858f6f92ea1477d8f3cd55bdcab40e55bd76b16dcf6b4060c9f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "594a9e8e28d952624635d6e7e8d7b79b13c2e13247c3fda11eb66010888be543"
    sha256 cellar: :any_skip_relocation, ventura:        "684a20162c61deaebe6de9d2778c0f740ce4523d2975896ecfc7e232f4e05742"
    sha256 cellar: :any_skip_relocation, monterey:       "15331bc1256648f59d8675aef08268dbc026bbc20386da0b266c6eeae8c585ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "594c5b21308fc002f11e026c2f5091fc1a95caa1248a2f486c57cb59f2a2bdd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be364c0ab85c650ad1233876a967cdfbe38e41ba0058c7f176915f3e0f427e8"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/7b/3e/1de6748e2f789cddcc3724caccc4876a862af563def5cbfd760566c9e828/pypdf-3.16.0.tar.gz"
    sha256 "71fd274f5e02c7122f688f5b2609407d5dd92ecb4140d498108fc94ea9573800"
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