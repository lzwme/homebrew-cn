class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/98/0b/56dabcf2b37d9152090bcd5d42e28ad312c9ba54fb1446b22dcc809dd84a/setuptools-73.0.0.tar.gz"
  sha256 "3c08705fadfc8c7c445cf4d98078f0fafb9225775b2b4e8447e40348f82597c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0feca8a8cec0ddeb320440508d0f4630b00318610e51a63cae0c471ac2fce66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0feca8a8cec0ddeb320440508d0f4630b00318610e51a63cae0c471ac2fce66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0feca8a8cec0ddeb320440508d0f4630b00318610e51a63cae0c471ac2fce66"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbbb47cd7eb9d07bcaeb839d816984b2c33211dfec5a4715bce1bfbbe5d97711"
    sha256 cellar: :any_skip_relocation, ventura:        "fbbb47cd7eb9d07bcaeb839d816984b2c33211dfec5a4715bce1bfbbe5d97711"
    sha256 cellar: :any_skip_relocation, monterey:       "fbbb47cd7eb9d07bcaeb839d816984b2c33211dfec5a4715bce1bfbbe5d97711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bf54683320840b92263bfb9d807fc11510320ebf9770738ebb9b757f41c6ea"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end