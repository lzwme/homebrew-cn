class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
  sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ef91bf95a1da28e053abeb24b8edd265d35d9c4cd8b9939e5d67f664c26f94e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19d397f59056ddfea107a5dd961a757d1ab28e9b78b62f29d7ac76e4aaee3ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb0c8c82dc9e754752f8e88cce3ad0e540aad9415a6809d694f753edb0ef8c1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "831f03611c0d478e4bbacbeefee6936291cbe3d2f5dce1b7c774be029f2ab1d8"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6a3b104b2084770217060fb7a326d7059f05b103be4f03604d9b9883ea7ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "13531b0f8a67c7695219dbafa5e6e380d0b01a5a34b8108791cb52c8b1dc9ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9850197bff670800df67501c13ccac13dde63404f2b033d2b4bb207654cc6981"
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