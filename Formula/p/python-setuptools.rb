class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
  sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dc19deb18ad122f26f6201aa5191acfdc95da06bf1b02d1fbd530e7497d5102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc19deb18ad122f26f6201aa5191acfdc95da06bf1b02d1fbd530e7497d5102"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dc19deb18ad122f26f6201aa5191acfdc95da06bf1b02d1fbd530e7497d5102"
    sha256 cellar: :any_skip_relocation, sequoia:       "4a828685a6098a2045e6ea0de9ac03d335f9cde04ec3650c1d3cddb01de59a9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a828685a6098a2045e6ea0de9ac03d335f9cde04ec3650c1d3cddb01de59a9b"
    sha256 cellar: :any_skip_relocation, ventura:       "4a828685a6098a2045e6ea0de9ac03d335f9cde04ec3650c1d3cddb01de59a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354fb7eb8b83f3a4e8f2ccf215e429d08b0945acf108676cf371b3779a3d59f6"
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