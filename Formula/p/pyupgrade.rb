class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https:github.comasottilepyupgrade"
  url "https:files.pythonhosted.orgpackages7a7915cd93e47b5d670f0e32a540eb3f11bac4b5800cf1f796590eb448c6a768pyupgrade-3.17.0.tar.gz"
  sha256 "d5dd1dcaf9a016c31508bb9d3d09fd335d736578092f91df52bb26ac30c37919"
  license "MIT"
  head "https:github.comasottilepyupgrade.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "efec23c73abb53500496a90a7aa43c1dbb11a63829d3b3c6443bcadf36fc18c5"
  end

  depends_on "python@3.13"

  resource "tokenize-rt" do
    url "https:files.pythonhosted.orgpackages7d096257dabdeab5097d72c5d874f29b33cd667ec411af6667922d84f85b79b5tokenize_rt-6.0.0.tar.gz"
    sha256 "b9711bdfc51210211137499b5e355d3de5ec88a85d2025c520cbb921b5194367"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~EOS
      print(("foo"))
    EOS

    system bin"pyupgrade", "--exit-zero-even-if-changed", testpath"test.py"
    assert_match "print(\"foo\")", (testpath"test.py").read
  end
end