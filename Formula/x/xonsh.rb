class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/60/e5/2dfa99e21a8118bed0e73ed50e91962fdad01b900e23497064e8810b03b5/xonsh-0.23.2.tar.gz"
  sha256 "633608c8292938af0f242f05326cc2912f25fa72bd808824ab0534a6df304402"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a586589b9ff3a63b83f2eba6254a6c6dd73f95e73c3c603c36747870ccd9ec33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a90789dd994b5c9e64aaa56ad964e2ac915901282aa36678ade9403a0e0161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943f8dc2cb3e4e9a995cef13b8d091dee904bd5ce468cda6c0a14c619e87cda6"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ca7219d43372cbcb11ba82cffe159fae38487b0cf227e19afa11efcb3f6337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d239adc3813cdaa35d5f3f82d055cd509f498794eb9eab52bd2fb751c672395b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e14c3984a102419242aa3a9e96c3f493323de66abb71872772ae8d29ea84b0e"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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