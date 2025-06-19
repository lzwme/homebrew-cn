class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https:python-markdown.github.io"
  url "https:files.pythonhosted.orgpackagesdb7c0738e5ff0adccd0b4e02c66d0446c03a3c557e02bb49b7c263d7ab56c57dmarkdown-3.8.1.tar.gz"
  sha256 "a2e2f01cead4828ee74ecca9623045f62216aef2212a7685d6eb9163f590b8c1"
  license "BSD-3-Clause"
  head "https:github.comPython-Markdownmarkdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44ba2477ecc491890eeb41eee3099102b2be362489654e649545c058942e932a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!<h1>", shell_output(bin"markdown_py test.md").strip
  end
end