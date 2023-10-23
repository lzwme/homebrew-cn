class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/62/25/1b21a708e65a933e9e2ecf03bfc7fae7169981cc688155cdb581de3e86dc/Markdown-3.5.tar.gz"
  sha256 "a807eb2e4778d9156c8f07876c6e4d50b5494c5665c4834f67b06459dfd877b3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b5eb30b0d5c5c57d670ceba9ae8a82d2a757d632768f08044f3a50373916cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f8b3339b407ec070d1c55f29eaf67c90ced12789c30d87d3936508d7102c213"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "648e880178f80041c1157c7ab4ed96872def3b0a7c593bfb837ff3aeeb69188f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d0c3d3e1a7cbe9541c2e094f3e22f209df2877484662ff6ce8ff7d3bcec66a2"
    sha256 cellar: :any_skip_relocation, ventura:        "2c1bb2ad6f357c4290172349b67c98bc71bf69179c92ff58d36ea563d112e55d"
    sha256 cellar: :any_skip_relocation, monterey:       "615fc8a0ea39cfa373ed61b166cc3496976d61d96386d0e31cf0939e2a75d361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e31a4da91d234f024cb3e35db9b3fe5599fcb30ad8473f45a7cfcb2d00d3893"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import markdown;"
    end
  end
end