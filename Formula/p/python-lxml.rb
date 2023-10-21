class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
  sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fa99716651dbd2cdf8d29d2c1bf67e60cef7ebffa3cecfd1a2471dedecec759"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc539279b955f01d0906f6bc5ddce1bf77401697f90c1dec94dc45d24c3bf91a"
    sha256 cellar: :any,                 arm64_monterey: "0f2c0ebe90890be17a697750a2243bf054f5dec6fabf87d4c4b6a568f4b5494d"
    sha256 cellar: :any_skip_relocation, sonoma:         "331bb6fdfac90d78dcf1b64c7f811b7bb90284bcff4550cbe430e6bb4060ad10"
    sha256 cellar: :any_skip_relocation, ventura:        "b8e5f1eaf2e36302675805a2830b38ff2fd140aff4334092a8caaaf678996ce1"
    sha256 cellar: :any,                 monterey:       "741f832eb661aa8253c44dc7fab10090056de212f4e75030971be62f57074963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279de0766560c7fb73dc450ba74126c04c9ca1a0866e1d0f15e701bd8c3b2b50"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import lxml"
    end
  end
end