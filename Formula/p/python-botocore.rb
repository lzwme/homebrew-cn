class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/77/82/ccd0b8fae17f05d9db896981bc084f2e913b672e99f16aea631c8ff9d008/botocore-1.33.7.tar.gz"
  sha256 "b2299bc13bb8c0928edc98bf4594deb14cba2357536120f63772027a16ce7374"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2ebaa40ef05ce8dfc658b32c154df3daf2a0556d837457ecf7e5393cd9c43fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2e097925124b2f90af0c5f914e360e3fd4efca27137971217f0f012306355a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0691911663dcf7194918946bec53ba9d10ae9418eeaef4076b9f7f7c6a3e16ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "4277054b575791717070ce23ca255f3dbca7256c70ea60b4b3a6e471a3b5e8b4"
    sha256 cellar: :any_skip_relocation, ventura:        "a29cd3ac60857bbeb67a136289dcda273674ec5780f8d44d18750de17a3bc87a"
    sha256 cellar: :any_skip_relocation, monterey:       "4e7a555a87764d8e6c63ad68f6e8cbeaa252c482d96f269d7c356249d0b3457a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3557819e83b780861c28c73727158f50779f08587a939ec0108e553cdc587bc7"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-dateutil"
  depends_on "python-jmespath"
  depends_on "python-urllib3"
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
      system python_exe, "-c", "from botocore.config import Config"
    end
  end
end