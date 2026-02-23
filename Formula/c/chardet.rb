class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/7f/42/fb9436c103a881a377e34b9f58d77b5f503461c702ff654ebe86151bcfe9/chardet-6.0.0.post1.tar.gz"
  sha256 "6b78048c3c97c7b2ed1fbad7a18f76f5a6547f7d34dbab536cc13887c9a92fa4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69a0c9fff6b040669876b5459d2c45c0cb30fb1e1a72946b17dc78d1eec0812a"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence 0.7525", output
  end
end