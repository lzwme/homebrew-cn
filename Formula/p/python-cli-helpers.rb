class PythonCliHelpers < Formula
  desc "Python helpers for common CLI tasks"
  homepage "https://cli-helpers.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
  sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1eee124efb5590747b92e7a8a080be21f752951d96b3bd0a6605c3c5370e3bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "197511fc0b0770c3dc36a6051e1694a12657566b06c46a6b08d796d6f45ea941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c88dd9899caf25a7a5b8f37e19f7b9386d0bac6467def61ced287079430b72"
    sha256 cellar: :any_skip_relocation, sonoma:         "8152e4169732cced9070d4fa3473699ba5cebffc83fa6257bcb4dab696e753cc"
    sha256 cellar: :any_skip_relocation, ventura:        "946cd5a1a405d2a48ef4c4f486c1414a05e2cfffece3c8397290786f457bb0fb"
    sha256 cellar: :any_skip_relocation, monterey:       "6529d4aaee02f9a63f55a8e9b970afc860d61411af94296dfa9db0a1d1ca2ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3732e75c3806bcb62e1b6808990f6da30f657e06e577d51f6321f4641ae4a75e"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-configobj"
  depends_on "python-tabulate"
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
      system python_exe, "-c", "from cli_helpers import tabular_output"
    end
  end
end