class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https:github.comcontainersramalama"
  url "https:files.pythonhosted.orgpackagesc2c5d4878a1f888a6c2272c06c7343ab11b92f6a450fdc85e872541afcfca9deramalama-0.6.2.tar.gz"
  sha256 "2f1763b38bcabc20bbee41b3bf0b0fa3c31e19c30659333a2f0ec368c0a28f4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2018fc643fc16d5a8ec760b43f896a1898f66f861d6b3f481c6233e51ddb9dbc"
    sha256 cellar: :any_skip_relocation, ventura:       "2018fc643fc16d5a8ec760b43f896a1898f66f861d6b3f481c6233e51ddb9dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aef9dd9ab509216691bc48f0e7255d5dac4bc1f5f271029877be63bc559b844"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0cbe6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}ramalama run invalidllm 2>&1", 1)

    system bin"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}ramalama version")
  end
end