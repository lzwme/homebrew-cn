class Auditwheel < Formula
  include Language::Python::Virtualenv

  desc "Auditing and relabeling cross-distribution Linux wheels"
  homepage "https://github.com/pypa/auditwheel"
  url "https://files.pythonhosted.org/packages/79/4b/640fb9c5e9d0310f8209f276f093bdd1ffe09aeb029296a80157d82602b1/auditwheel-5.4.0.tar.gz"
  sha256 "aaf8153ab7a29cc99a663ce2498804daf1887ea1b7a3231ba0d3fee68a3ccf19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d5c4e8a43af16fb81fd4ac6e481e69f3e23cf1f764d77773070e29757a1da87"
  end

  depends_on :linux
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/84/05/fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8/pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/auditwheel -V")

    resource "homebrew-test-wheel" do
      url "https://files.pythonhosted.org/packages/4c/00/e17e2a8df0ff5aca2edd9eeebd93e095dd2515f2dd8d591d84a3233518f6/cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl"
      sha256 "2d92b25dbf6cae33f65005baf472d2c245c050b1ce709cc4588cdcdd5495b520"
    end

    resource("homebrew-test-wheel").stage testpath

    output = shell_output("#{bin}/auditwheel show cffi-1.16.0-cp312-cp312-musllinux_1_1_x86_64.whl")
    assert_match "is consistent with\nthe following platform tag: \"linux_x86_64\"", output
  end
end