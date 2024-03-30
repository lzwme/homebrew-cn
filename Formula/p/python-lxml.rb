class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https:github.comlxmllxml"
  url "https:files.pythonhosted.orgpackages73a60730ff6cbb87e42e1329a486fe4ccbd3f8f728cb629c2671b0d093a85918lxml-5.1.1.tar.gz"
  sha256 "42a8aa957e98bd8b884a8142175ec24ce4ef0a57760e8879f193bfe64b757ca9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc181ca25eb1b819aa2a32db6b69e5c1244abdd8cdfb5803082bc966668d1550"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d868e77e27a98776db1333ef8d458e380b865205760fdc0e973e88780b4beb1"
    sha256 cellar: :any,                 arm64_monterey: "5015e6c96a33e59ab1eece8d052649936215809ce8941d40042e8113004a3626"
    sha256 cellar: :any_skip_relocation, sonoma:         "262833be2eb879a0db418fcb104037544ad18b749a25b1ce7440a0cb84edb48e"
    sha256 cellar: :any_skip_relocation, ventura:        "86189d0c7f4ae370677657898a1e669894678b7d76dd3e9ef2caa699b92bc3c1"
    sha256 cellar: :any,                 monterey:       "d86b31c0ee9eb154d1e4cd6fe0ae574c3ceeb36267d4cb682d45c4e46e12a596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79eecc9913109fe6d072d6c1816a659e4e4502c6c5924501987bcdca00610848"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import lxml"
    end
  end
end