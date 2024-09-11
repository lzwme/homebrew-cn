class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/3e/2c/f0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6ef/setuptools-74.1.2.tar.gz"
  sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "578730d2480c6dc8b5098b1e42320f314e91104c59c85d793ac506eafd2cd06a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "578730d2480c6dc8b5098b1e42320f314e91104c59c85d793ac506eafd2cd06a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "578730d2480c6dc8b5098b1e42320f314e91104c59c85d793ac506eafd2cd06a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "578730d2480c6dc8b5098b1e42320f314e91104c59c85d793ac506eafd2cd06a"
    sha256 cellar: :any_skip_relocation, sonoma:         "14479d8f8bc110d9845e69c7e6d4cdb63131490ea63f81e9e276d938215afe3a"
    sha256 cellar: :any_skip_relocation, ventura:        "14479d8f8bc110d9845e69c7e6d4cdb63131490ea63f81e9e276d938215afe3a"
    sha256 cellar: :any_skip_relocation, monterey:       "14479d8f8bc110d9845e69c7e6d4cdb63131490ea63f81e9e276d938215afe3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "498f4697b47f4191fdfb0ab343fe55fc1a69b95ba86a72d0b57141c514a83cd3"
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