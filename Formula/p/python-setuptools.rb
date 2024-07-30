class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
  sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74229994656f72b76e44ee168eab233b9bb1d07a479095998493eb7def952210"
    sha256 cellar: :any_skip_relocation, sonoma:         "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, ventura:        "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, monterey:       "735a65ff7704697e732eeb68cfbbaa9309024bc8f904d1ec13f8045e9b30ec17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8455722c96a7578f8f7b2b9ffe4d0674b35d9d275bcde824a578e7c1223465af"
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