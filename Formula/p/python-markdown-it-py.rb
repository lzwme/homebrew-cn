class PythonMarkdownItPy < Formula
  desc "Python port of markdown-it. Markdown parsing, done right"
  homepage "https://markdown-it-py.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
  sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbcf9ddde22e549ffb6fe24f29cb3a0865674a66717a7f0c12d7db0bb0c858cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6b868ddd6d194db968792a7ed9359be04dbaaacdbc1328a61c73195057c1b5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bff912d6fbd630bd809bee85a435883aba16510cfbc24604f12c70d01ccbda09"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c1114f8d7dcba29538c376e33200d2b9e6cfc761fba35903f94b76684461435"
    sha256 cellar: :any_skip_relocation, ventura:        "804ce5e5948e5cf827bdcc5e1a8315458e3090f315ecba68e11f63569812a69c"
    sha256 cellar: :any_skip_relocation, monterey:       "acf5f2c1a832ac79ec7b7976e6bff23479402dbc3d71f68c82e25de9ea878e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620d8a6c75ae692cf2c636cad09566b676b5105029ab684e963410b2ed159bb9"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-mdurl"

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
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from markdown_it import MarkdownIt"
    end
  end
end