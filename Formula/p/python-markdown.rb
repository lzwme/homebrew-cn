class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https:python-markdown.github.io"
  url "https:files.pythonhosted.orgpackages22024785861427848cc11e452cc62bb541006a1087cf04a1de83aedd5530b948Markdown-3.6.tar.gz"
  sha256 "ed4f41f6daecbeeb96e576ce414c41d2d876daa9a16cb35fa8ed8c2ddfad0224"
  license "BSD-3-Clause"
  head "https:github.comPython-Markdownmarkdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, sonoma:         "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, ventura:        "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, monterey:       "d768ef8b25a991d85f25f9b54ccda3b0156a5f2a1ccd1b41a878f9dfb9143c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3a6fb9c640fd8b1bd6ec3fefd3f1741db6be5e754c35bd0e230c1c996a72e1"
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