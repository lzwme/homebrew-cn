class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0d/84/e72ea5c06e687db591283474b8442ab95665fc6bae7b06043b2a6f0eaf6c/chardet-7.1.0.tar.gz"
  sha256 "8f47bc4accac17bd9accbb4acc1d563acc024a783806c0a43c3a583f5285690b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbc60599ea100aea3d528c2d0feb47b25d2c551d9b7768465230330815f3e614"
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