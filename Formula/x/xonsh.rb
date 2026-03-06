class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/6f/c8/bbaa8ac73f7fa19d9ae05a19d0ef088ceec675523fcbc138e4b3c6699985/xonsh-0.22.6.tar.gz"
  sha256 "830df3fd7d403b5efa255b199bc3aecb4357f46964c37d5c4b05b19b69d156bd"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7149c6bba10a7371c1f6acb3c7acf428fcec6b699884af79d4b24d36e68a2564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e444048acacfefca535ad61c18316da64f37846d67bc66d93c7a7aecde033c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5349ff555ad93fdccae8f9c909376a52e98d46085b39d4ebfc955aca17636912"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde0d09bc990213507b4f071f77eea6a0b564cde0ba3c25e600fa6f46ebcbe46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9cc24c5af25c8618b29dd59463965b6d4313108469ac90f4bd6f97e687e4a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98cd6172706cb1e114c7fc889a7ef6e8dccff88b7b1cf9dbd1e34957927717f5"
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
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end