class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https:github.comhylanghy"
  url "https:files.pythonhosted.orgpackagesab7ff8061ae737f6a564c3d4f80287bd5ff46afc1f606617a9cb5c797e6a974ahy-1.0.0.tar.gz"
  sha256 "3a00013e075ff5ce8f5d475ca2be47e4c871f09184ba3533787cb544d32d1f9e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "42597ff82da7cdb389a796c62a21df69df5e342fbe8d52de5cb58cb26fa09de0"
  end

  depends_on "python@3.13"

  resource "funcparserlib" do
    url "https:files.pythonhosted.orgpackages9344a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}hy test.hy")

    (testpath"test.py").write shell_output("#{bin}hy2py test.hy")
    assert_match "4", shell_output("#{libexec}binpython test.py")
  end
end