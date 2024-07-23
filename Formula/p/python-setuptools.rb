class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/32/c0/5b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931/setuptools-71.1.0.tar.gz"
  sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab8eb262297bfe67ef9ba4ec7d6de3ce941e00d55f09a0a2594299151fc6d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, ventura:        "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, monterey:       "160f5ed98d10a734a476a640bac00c01624e7b3736c9fd28d3f4ec33dc364988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426d87eeba12fcbbc9267807beb3aadf67d38b88fb2eeaa2432826976c7e654d"
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