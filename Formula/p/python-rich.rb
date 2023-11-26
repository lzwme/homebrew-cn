class PythonRich < Formula
  desc "Render rich text, tables, progress bars, syntax highlighting, markdown"
  homepage "https://rich.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
  sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce8c39f4e5060c218364085263acd3d96f5698684706107b533c2a26219fc416"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e568f44d6ea8a63381d0c0e8ee4da5ff3808796f0709a04f89fd3950dbefe1a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "909520205740d52899bc786e5cbeb9c8eb7343f801d36be714f7f99bd4ed5d34"
    sha256 cellar: :any_skip_relocation, sonoma:         "5559e962c8487b6234241fb337a411909350a07f2ca7e28e9dcc62cb78014d81"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7a436a4b9c1fc5cda1ff86c9827e278ed8509d66599dbfac38cebfd4679767"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca8c6ee3a20069691e73e9b985364105b518a236a4ffac5a62cc5a796bc4d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a077244e4d1adc23d0f61ddbae0429ee796f0669e03a49e7cbb3f7f6fb8b79f6"
  end

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    site_packages = Language::Python.site_packages("python3.12")
    ENV.prepend_path "PYTHONPATH", Formula["poetry"].opt_libexec/site_packages

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from rich import print"
    end
  end
end