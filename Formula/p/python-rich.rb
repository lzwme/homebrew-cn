class PythonRich < Formula
  desc "Render rich text, tables, progress bars, syntax highlighting, markdown"
  homepage "https://rich.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
  sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bdac72c4603be56977d316a2faaa8b3a872e37d0d71b5294e3c8eb7584cd9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74942cf9462c32bd4f5ad67583d8965056cca5e662b4cc3d54d25caa8d8fe233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbec0aa47c29a1c3c6575077d5828e22ce0cca5c8fd997312067b174516240c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e2802e9753979b28ef295a72b78e6ac34214b2c4b7448207e4afa8dd01edbb2"
    sha256 cellar: :any_skip_relocation, ventura:        "72fe9524538a566f3536cd2b4af00f517b5ca6cac9921f5936d027bebbe92baa"
    sha256 cellar: :any_skip_relocation, monterey:       "1f0df4163a2390f312df9a705e5f711d0081525dfce216dc073f9f66cf30df21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed255505e83a5e57a4e7078630d414da5bb31b163a93b826dd734dead5060121"
  end

  depends_on "poetry" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pygments"
  depends_on "python-markdown-it-py"

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