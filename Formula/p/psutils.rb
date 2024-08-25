class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https:github.comrrthomaspsutils"
  url "https:files.pythonhosted.orgpackagesff468b697d7976ceccd4971886f04b57ec3ef46d8976b2beefa97892bfa35271pspdfutils-3.3.5.tar.gz"
  sha256 "49d0ed8254df3fe60eb4fd74d4dc1ccaf08cc7802ea9d79d83670b45685d5e35"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8721074e2c724d5069bd6c8be15e93a05e1954e52de0ca09829ee638479858b5"
  end

  depends_on "libpaper"
  depends_on "python@3.12"

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesd5cedc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pypdf" do
    url "https:files.pythonhosted.orgpackagesf0652ed7c9e1d31d860f096061b3dd2d665f501e09faaa0409a3f0d719d2a16dpypdf-4.3.1.tar.gz"
    sha256 "b2f37fe9a3030aa97ca86067a56ba3f9d3565f9a791b305c7355d8392c30d91b"
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