class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/b2/9b/c154d7694227ff8f5ee5bdff2f8cf8a529ba8f53e80806dd984737c59b19/setuptools-71.0.4.tar.gz"
  sha256 "48297e5d393a62b7cb2a10b8f76c63a73af933bd809c9e0d0d6352a1a0135dd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "493719957f7a6a56beeaed180cb6b696e5a08e6e67c7ee29fa688513dc915ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "493719957f7a6a56beeaed180cb6b696e5a08e6e67c7ee29fa688513dc915ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493719957f7a6a56beeaed180cb6b696e5a08e6e67c7ee29fa688513dc915ce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5354829063ce881de41d122f701be66c30940c59eaf4ed8eba859e0c34c5a932"
    sha256 cellar: :any_skip_relocation, ventura:        "5354829063ce881de41d122f701be66c30940c59eaf4ed8eba859e0c34c5a932"
    sha256 cellar: :any_skip_relocation, monterey:       "5354829063ce881de41d122f701be66c30940c59eaf4ed8eba859e0c34c5a932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9943cb522c17318d64c3bfc28d917c4f50479d22acb6a709cd6212bc1f9fe655"
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