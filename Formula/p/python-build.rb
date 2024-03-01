class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https:github.compypabuild"
  url "https:files.pythonhosted.orgpackages9cf88e713caf591c7e7d40890493546c5b76d6fc9824ea6907a89168b68ba903build-1.1.0.tar.gz"
  sha256 "f8da3eebb19668bb338b6eb256b1896ef4e87a5398bbdda97ee29ec474569f16"
  license "MIT"
  head "https:github.compypabuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "593d155dec63e6b2099621d2799061ce88c20500822ef5aa22ca0a80e5bc4277"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d44b43a4fea53525cc8a93183673bf305082988401624e516aea997a3e01203"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cff421557f64e0809767f36cf0af30c27c6ca43df14b2589e10d4cd1d345ca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b570be0ba4c01c5735a52a9b1ed5f5f9901a4088233f9a16bb7884bd4e1080a"
    sha256 cellar: :any_skip_relocation, ventura:        "8745954ecbb237671e99351c3c4cbdb4c789cd433ac091a602480c02b4373e2d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef185c7aabd0c07ae6a5dc70b8d3a0130e6d7566b19d2dc2d6f93a7466160258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fa48f44b106dee990474210eaf900ce50c13920ef1e9cfec4a3c05bcea5c7fb"
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