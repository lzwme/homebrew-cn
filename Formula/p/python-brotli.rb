class PythonBrotli < Formula
  desc "Python bindings for the Brotli compression library"
  homepage "https:github.comgooglebrotli"
  url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
  sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  license "MIT"
  head "https:github.comgooglebrotli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb45ea067027e4be88c6def560384d785d1a3cd2038bbd60e702aa18f3582f6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9268f3b14509a185b3ad3440ddaee09c3f36adefd6f54e5836f17b5e2f941dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21546fed9ef563a3c7aa8868539d99378d86478948cbed95525c12f4ba84b88"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7751b224f4fe3bfeadff329e000a153c11bdfc31555aa4ad020f23f1691e137"
    sha256 cellar: :any_skip_relocation, ventura:        "a29fd74db43f5758d4bf8b1de4a916e870336861359cafad08bf13434b28dc9e"
    sha256 cellar: :any_skip_relocation, monterey:       "7b463aae0db03af515c8c3754e6aade4a5ac555949cfd5666a7a9328539f5196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a582faa6e2f54644f22b565ae5fc105654576898d9d6000010db63f796c0af"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
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
      system python_exe, "-c", "import brotli"
    end
  end
end