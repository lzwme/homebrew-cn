class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/5a/2b/3c20de9b70fcf097d5e1b0b50dea677fb23ce9e672d9541493058e23f3ee/xonsh-0.21.1.tar.gz"
  sha256 "9d3849091a6e4252ad0d500cfd83e4d8a2043f54d67e318541e7a773070a64dc"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a84c77a5de47161bd8ab17d3e989920a123a99ebc36607f16e168e62023883ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45bce53a7169cea6f0981ce2b7edb3ddb63f3cbcd1ca5bffdd50b31cdfbdf5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5ed08139709142eef608ef9165964c2a645db42aaadf93699f4ed2eff1eae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d2ce1fca814b2d8cf53b5b084cad27c12607faad9edde1033cce23f2a3b91e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b1b9dc2b1b38e746272faae937df6a01890574c7a17e2e93fdef8d17f793c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ffd2b7185d0e4e57459175b099ceaa7a57f2639d436180c96dee8f1cee308f6"
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