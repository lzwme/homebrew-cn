class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/8d/37/f4d4ce9bc15e61edba3179f9b0f763fc6d439474d28511b11f0d95bab7a2/setuptools-73.0.1.tar.gz"
  sha256 "d59a3e788ab7e012ab2c4baed1b376da6366883ee20d7a5fc426816e3d7b1193"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d67fb05597ca4e5250c551333b0a3a4604dd29c62af3b2e48fc762deabb79bdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, ventura:        "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, monterey:       "658bee7b856a56286109dd83a475a13ffc1a0e7182fe59bd009547d4c261146d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39cf7e8f3fa3d30cb456c3c1c432f2a5b18fb97e81ea6c68c4cf96bdc068ce7"
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