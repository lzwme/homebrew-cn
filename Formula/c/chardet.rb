class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/56/7c/c9cf52695364a0609829ccc9e88adea553587ef70349314f29ed1b62bcff/chardet-7.5.1.tar.gz"
  sha256 "0df08f2b2f6ac04b3e7f9e8ad1b1559c2e8497338ff9dfa1e0922335ff9dfe8d"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8139ff6b12810567c4d91d04e84fb9e15f9bebe089bc1b259fe706321caae4c6"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end