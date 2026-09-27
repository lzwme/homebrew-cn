class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/f8/4f/700155c8c20d9e655dd0732b5fc3c7614f291b9148da271d7388e50bf774/markdown-3.11.tar.gz"
  sha256 "180224db6aed87ba9ce1f2781ebcd5826253de8ff637112090e24b84502bbf9f"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "01c789db4a61837fa47b27d3e65be60392e9a0e2ed711fd8923de820e8c35b42"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output("#{bin}/markdown_py test.md").strip
  end
end