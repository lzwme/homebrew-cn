class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/98/e3/83a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1/build-1.0.3.tar.gz"
  sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "956e021cc014c6b1601984e7feff66f0245ea10380262e68182a55acb9b10f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26a65bd9866f8e4f1355a75cffdc6d35c2eec22ef47aa361222cec39c29ff5e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca00dce67a2c83d81c04c807c0508ec2a8253bd82f44f266397e547f0f7c5d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dda5797abdf1680f250ff942d006da6bec9422048de190e4653d58fbaa2ff434"
    sha256 cellar: :any_skip_relocation, ventura:        "2449fc76f7eaeee8bff032a1054f651d45135eb5c950ddbd33d07c3d758ed7b3"
    sha256 cellar: :any_skip_relocation, monterey:       "68011a81160b3b8a0528a102d12fbe696069db857c1b142a8a6e731cc3a5e996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99d3e6a03e99a71bc47add889ff3b7984500ca30da1a5a20508b8b80728916c9"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-pyproject-hooks"

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
      system python_exe, "-c", "import build"
    end

    stable.stage do
      system bin/"pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end