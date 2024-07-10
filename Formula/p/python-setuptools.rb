class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
  sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d26ae734c39e859e1366b14bb15391740f7db02fa1d383a7f67d03b1159653f"
    sha256 cellar: :any_skip_relocation, ventura:        "3d26ae734c39e859e1366b14bb15391740f7db02fa1d383a7f67d03b1159653f"
    sha256 cellar: :any_skip_relocation, monterey:       "582d5089333a9dc3a33b159d6cc261e8f620cd60f657dce5e34d12365eb0535f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4891411677a80b8fa10903357526de1b19b7b70d373dfd16b95162b09e3ae878"
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