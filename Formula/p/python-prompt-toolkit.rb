class PythonPromptToolkit < Formula
  desc "Library for building powerful interactive CLI in Python"
  homepage "https://python-prompt-toolkit.readthedocs.io/en/master/"
  url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
  sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "833dd8a0ec1381ca2e9960f02a4d72452bc9f900972f90f8ed44e8dd33afb886"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4920f959794a62e9213a16bd1073cd88f7d7ae12a877e83a3e9d1cabf8924c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be9e3755bd28fffe695f1b2862ad91dd9d38209bca42dd33139fc35755584ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfa4ac4bfa3aaeb4983f7df821d97a439f33e56ab65d79bbe9cc85022800d061"
    sha256 cellar: :any_skip_relocation, ventura:        "d46ba018eb6ccfe84eaf10d0d66dd4002ff4935d3c2201c87364bb03dd61c8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "a110eadf2d8998f45dcb3653b3829e6c4b6e8e60f34445101d22779054cb0d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600d3f4276cae515bb7bd0597dd5a410ff59693bf319d3df924ce459ef4727ba"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-wcwidth"

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
      system python_exe, "-c", "from prompt_toolkit import prompt"
    end
  end
end