class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/de/54/f244644bded1ef26ab7e8170416fa0a4149a509c56b36121e9137d1b9d2c/botocore-1.34.13.tar.gz"
  sha256 "1680b0e0633a546b8d54d1bbd5154e30bb1044d0496e0df7cfd24a383e10b0d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "063790ab1c5329984407af3e6a2d9889fee3cbedae63ba209c693870ab456112"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "433f103d351af36c7aeaec2b3518e173313b271a636f6049e3587551611b634b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677d4a99303e534abe7062295aced983bfd48799f267af5e0c37d7407dd98ed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dfacecc19324106cd9a02d02b60f55c35fe88e118fd8110e903e0bb7b50a383"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb09736642c9f68a21d864d5ac243e275a79e5c78236e048152e56b019e8ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "953bba686693098af9b67f334898aae871c293825272f91660a4a635a8f2ecce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e93ef43f15424d3903f4e4fbef8f49107e4bbc43e32fd9cd317905808f911b"
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