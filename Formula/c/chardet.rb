class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6c/80/4684035f1a2a3096506bc377276a815ccf0be3c3316eab35d589e82d9f3c/chardet-7.0.1.tar.gz"
  sha256 "6fce895c12c5495bb598e59ae3cd89306969b4464ec7b6dd609b9c86e3397fe3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "103902e99ed75c301930256522261c48fbd5913df8bec9643bb65b471cdd4df9"
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