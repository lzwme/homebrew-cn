class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/c0/da/2565ca2ea7609388b49697653ef60c8588a61fa59346c56151c16e6ea0c6/argcomplete-3.1.6.tar.gz"
  sha256 "3b1f07d133332547a53c79437527c00be48cca3807b1d4ca5cab1b26313386a6"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaecc6ee932a61674a328652aefc43870e6770e5493c6a31f109995862debae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d434e9d29a9e276fea01bf58dfab7540495c1023c1241eafcc78690d88139b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ab0ab1909932193f374e0e3433ee552932b78d40d2881ac7af313b5a671d9d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "34d793285c0f9786639a45bf34b9b3e2e17e1a6c4b55b9e5f6f6e221042aef3e"
    sha256 cellar: :any_skip_relocation, ventura:        "515689af1eda35e920078c0828d145aadaf673616cad95e7d0da7139e6912fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "1cae4ed02101f2ec892cb13bd28ff4d731f81796c58db63017743df399570801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1422a6dd9709bf13597f191e21d827a9d82780ff0b4b31fb1604f68250f5a5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
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

    bash_completion.install "argcomplete/bash_completion.d/_python-argcomplete" => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end