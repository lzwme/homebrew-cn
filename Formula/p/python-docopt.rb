class PythonDocopt < Formula
  desc "Pythonic command-line arguments parser, that will make you smile"
  homepage "http://docopt.org/"
  url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
  sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f804f6c31e6df4ba8880fdbc9c1030b4cd6eae56924e9994832639c06a112944"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e587e2495d59c2ebfdcb22b715931a07f2e87d1e8341f50188e14257ee32f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9f17edb3a0e5bdf74f8b377f28fd990ae0498292ec496e8f1595a15c924787"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b4b587f08b74f18dd3617200e9a99e0a965138cf91b369dd0289271c5e755aa"
    sha256 cellar: :any_skip_relocation, ventura:        "0f592a51c5abcb8f5616ae48ca2c15ec7364661eca6bbbee767d833e4d41a7b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed338bcfd4b95dc86be5d6fa6db02f058d08733991040e2d84dc62424c8f8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d60229c71ba7b3ddf1f1453bcb1af1045d841e9e7bb6bf7f4f079074451eacf"
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
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from docopt import docopt"
    end
  end
end