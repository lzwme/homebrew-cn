class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://ghproxy.com/https://github.com/rrthomas/psutils/releases/download/v3.0/psutils-3.0.tar.gz"
  sha256 "0d223fa15661d4ea76ec3e22e28d2126ed71e5e4a53e8ef246aaa21cf8f76aa5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b60ae45d300b673f90ac1592902c85cbf113317cf6c470ef62ce294b44f2a5fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3c7cbea27a4ac5d12eff53fd44978bc085d68b8a656da7ea7ecf26e6a4ef320"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "864b86aab51497a8178dc66209459761f0ca091997bb609837f11dc3d5847a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3ff35eaf23c5bcb6990ef24596529d0b34b0d91bd49723a7c4608d37289cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f180e8e2de4bb9f16b29e06abeb6cb58eb6ad3ca1d175dcf038d5b4106ebaf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e977d3e49051c261e33012ef6482db073a5796ff3ded4d80d6ca0a71950748e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e9320c59bcaefb83f2275ce880f648fc776cc64d6ebc4aa3d1f297daf02c671"
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