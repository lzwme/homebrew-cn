class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/27/cb/e754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96b/setuptools-74.1.1.tar.gz"
  sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3b03ec4c44401536cfc2672db068b4e5f23a9d82a5521ca1c52db90c148bde2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b03ec4c44401536cfc2672db068b4e5f23a9d82a5521ca1c52db90c148bde2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3b03ec4c44401536cfc2672db068b4e5f23a9d82a5521ca1c52db90c148bde2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eecdc66e4fa2e9979177956311f9ba1d6587688c69fba23209b964b2a264ef7"
    sha256 cellar: :any_skip_relocation, ventura:        "4eecdc66e4fa2e9979177956311f9ba1d6587688c69fba23209b964b2a264ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "4eecdc66e4fa2e9979177956311f9ba1d6587688c69fba23209b964b2a264ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4906ba35e5eef0b8024cdb4079140f8c94a7a1d395ef425b4c03ebe46bab4c"
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