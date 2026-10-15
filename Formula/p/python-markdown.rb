class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/4e/d4/f3f4b6ed70b7c7608fa026ff3bbe59ace9b1ebca43d8ae4886c87c95e81d/markdown-3.11.1.tar.gz"
  sha256 "496f4f80f9ebd3395a04c8ec9595c40bbe8ec19e9c67d21fe071a1643e876606"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7378484244fa0f38cac09ac6a348831b84b1aa3d03002bbe901cae0cb07403a6"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output("#{bin}/markdown_py test.md").strip
  end
end