class PythonTabulate < Formula
  include Language::Python::Virtualenv

  desc "Pretty-print tabular data in Python"
  homepage "https:github.comastaninpython-tabulate"
  url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
  sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  license "MIT"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "301ef12bcda093517f342f155422ac944cf38a795940253ba4a9d9397a150c70"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"in.txt").write <<~EOS
      name qty
      eggs 451
      spam 42
    EOS

    (testpath"out.txt").write <<~EOS
      +------+-----+
      | name | qty |
      +------+-----+
      | eggs | 451 |
      +------+-----+
      | spam | 42  |
      +------+-----+
    EOS

    assert_equal (testpath"out.txt").read, shell_output("#{bin}tabulate -f grid #{testpath}in.txt")
  end
end