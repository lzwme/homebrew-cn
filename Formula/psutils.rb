class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/aa/5b/3aa9bc7815ca52e1fbe00c43196a3efc0d354cacca9bdf9d96f23aaf1d5e/pspdfutils-3.0.3.tar.gz"
  sha256 "f4f3b509d9c49d7febfcd92a49d3caa91961f4eba7558d405c0be389e71afecc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8831a0973b1914fb78308ed2a278aadd8a62132ffd04dd9e3e626baf56511459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c8710f6399b4271261f79d3105b033abe538baf00646718d8fd1e9ee74db00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "568bc8d0bf2bf828c5974571592d524828f4018ea35a4deffe692dffbd88aba4"
    sha256 cellar: :any_skip_relocation, ventura:        "bef036cfed1d1e339891325a4d97f6cc9a0c610f6ff66061a115de615fae0895"
    sha256 cellar: :any_skip_relocation, monterey:       "6ede47ada8feff822480aafad739e04a0da10ab7f1f9e79636083d1fd941d272"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d5cd50502f83e2be7c674abcb2d0e9e7230f17f002b72332bba0bbc557ea7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea826a977df9d4a277b452bb5a2bce7542ad15e8708d7b4305ce354f6af1407a"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/58/b7/63717fa462e8f54e66e460d95092e242d66d628e885773f4348e50faf0dd/pypdf-3.9.0.tar.gz"
    sha256 "06136b9ed99525159482a1397a49f3fc0fd55ffd700d1ad4393e3f42d192a035"
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