class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/99/06/4a802b802bae2c81a5da0a4c49806df46c9a9a892e87dd41269f10f82432/xonsh-0.21.2.tar.gz"
  sha256 "85bdc5577e22f587b3a3be7b5789335dbf9efb25e2f5f9d7a518eb7db39307aa"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0923a66ee64353d2e236d49c741227f30dffcfc1470cdffd57311dfc4c2ff741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf532df6907be2dfadb956377e77f30fdd39bfe0625415264a4d6678c11f4062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6be82fc936a2749832b52c9ccfa7a0b0bdbac19ec8fe8542d7306acd60417ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fddc2c1022ad3efbdc5ab28cc9b66f5e6814a4babbf66b031c26dd2351e1ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1666b5c2fc7b15627d3a8976c3aebb1421a2489f45afa3d309961389f633f49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29383237aea9b419c113b5eaa151de055d203271a91b8ca4ef0b8f150e64ac7e"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end