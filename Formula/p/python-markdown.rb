class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https:python-markdown.github.io"
  url "https:files.pythonhosted.orgpackages54283af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472markdown-3.7.tar.gz"
  sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  license "BSD-3-Clause"
  head "https:github.comPython-Markdownmarkdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2b07b7bb754954c44444f71599b7e8a7e8455bfc3c61d625a6b56fba16c2fdeb"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!<h1>", shell_output(bin"markdown_py test.md").strip
  end
end