class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
  sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9f57b66109b6af73dde80022baa8bdafe994942f56a206ed82a6b34eb033ea63"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence 0.7525", output
  end
end