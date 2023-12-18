class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https:github.compypabuild"
  url "https:files.pythonhosted.orgpackages98e383a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1build-1.0.3.tar.gz"
  sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  license "MIT"
  revision 1
  head "https:github.compypabuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e124971150ba80ab9d16393fc8459e5467cc2a830109c50aa1ea6469481a88cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c05da3dd3bf27fa9a255aacf3c6cd1199d109db6df7b142ccff8ab7fbd47a39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5471e851dadcb1ff0043857d09e19a88fad5c71a06f0256e4e5b778a6bdb20"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7e5485ce65492e9166911f2d41b2beb0787bb7c586fdde44ac81798b02cfe2b"
    sha256 cellar: :any_skip_relocation, ventura:        "4b13178342239b805c683627ff128882f6808badce620c229219e1de3c63c5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "2c375bdcfa72510f1f7d144dbcfc6a5333d74939ea06c780bd18057bec26c228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f7c8f74062691b7e6012d20aa4d596a27ebf74c90aba9dd9c753df4e1cbfd8"
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
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `pyproject-build`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "import build"
    end

    stable.stage do
      system bin"pyproject-build"
      assert_predicate Pathname.pwd"distbuild-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd"distbuild-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end