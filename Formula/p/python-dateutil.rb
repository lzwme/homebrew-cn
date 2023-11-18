class PythonDateutil < Formula
  desc "Useful extensions to the standard Python datetime features"
  homepage "https://github.com/dateutil/dateutil"
  url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
  sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9588cfa990f5972c65952e51e7f58856fb8de1261694bfde4d0ba4a9c4a56fd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b0abbbda194568db20130d21dcd638d24f4c8ee974b28733894299771ef109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ae949aafda8c215d77899937fae8778c273c926cf7e31b6443e7c80b4809cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "60456e95c50a57a5c5edc0b7dfcc0fc27654450257aced304bdf0aa8c887a43f"
    sha256 cellar: :any_skip_relocation, ventura:        "535d1a50c2820f9de80f821a5695d759bf8758018953bf4d0d94d6b2de0e935d"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6e9fddfb07df4d04f27e526355931e1f55ea4aba9934b1b808a48b753921b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7045a20948d3116bb2b2ec24a4ef5e079540c77d86fbb72748b6814e945b5e92"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

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
      system python_exe, "-c", "import dateutil"
    end
  end
end