class PythonClick < Formula
  desc "Python composable command-line interface toolkit"
  homepage "https://click.palletsprojects.com/"
  url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
  sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0e62cf041fda39feca60cb2593233d173b3a8cd5f09bd94ad22d451cbe9f5ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90501f4d3df8b062cf60613e1901ef2e20e9273634823b763d3575e84c60d5f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f46c3348f3ec3fb5181f2e084f32d74f346c7eedd554bc82c8b7b3a8e766af63"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c794b80c0fd7e7f95955b44ae0e247a92dad15cb1865b181cc3ffa6053ecf5a"
    sha256 cellar: :any_skip_relocation, ventura:        "f208aec0db9aa55c2c308ea70979233940398dabb28e7f38406d3d3a509ba917"
    sha256 cellar: :any_skip_relocation, monterey:       "a9cb822853ccbcb1f674edb8aee74db4d1dcfa092ddd9c0c7ae950e7cff4993f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eec539f70e2be29f892e88838a2a572dbc83c05b1cbdbe3f9cf90ed670a0a1f"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
      system python_exe, "-c", "import click, click.shell_completion"
    end
  end
end