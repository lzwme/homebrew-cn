class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/a3/d8/e485a7bdb64a126957c93b9db78ae8c608cd94975384e2cebc7af83f26a1/xonsh-0.22.0.tar.gz"
  sha256 "e4bd25a1d6be698444634212029109cefedccc3a6a85f2bacfde33bfd5461488"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9857457790f51d202fc5137e65a54fe37b2c21793d77f9143b8354490abef89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc52f11cf105d3d74d0df1861dd43a12bf2d139397fd187be1271b3c94bdeffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eebe77eb788c07e779b3a45010013d37be7e43660918aadc30340c9f4e42e879"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26333b693f682ad8dead49becf04f8d54d2fb33f962c56c413adaedd5e2144e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b7519ed63022cf2d544028edfed2ee8d4016ec7177496e2b6224cb7705a6eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d44edbfe919dc9101989f3fec3e34dfee8b614323deb4008ecb71c4a446bb4a"
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