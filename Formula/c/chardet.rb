class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/3e/af/8d6ad988a6a4b9830c4e39e4c2e390e3037465b76a5e32e92273df27a973/chardet-7.3.0.tar.gz"
  sha256 "e6bf602bb8a070524a19bac1cff2a10d62c71b09606f066251282870fa1466e5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e39f8e870d745309f53ec9d8eae94a7879a31641a3de44e7adf7c4f5397c95e3"
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