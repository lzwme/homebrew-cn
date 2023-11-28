class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/38/76/40bc076d9d910587d3cece2dc3226646fd34456895975e36fcae3acb74fd/botocore-1.32.7.tar.gz"
  sha256 "c6795c731b04c8e3635588c44cfd1a4462fc5987859195522c96812cf3eceff9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2e8f7f70530b7f1d004bec0b011b7ad6339bd5c60baae2f37ca29eff0f2b72c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f86dddefe200d35604b4e6451d181e1d8cc216f7feacb8ca108e65c376f5fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f02e5a691065e8fd916926142a586f1f9f2c1661063b2ad778a9249275a48b55"
    sha256 cellar: :any_skip_relocation, sonoma:         "19a6dea4dec97c96b94b8d74f0e328d9b485340c7a2e0b0b9b92a6a570403a78"
    sha256 cellar: :any_skip_relocation, ventura:        "874a9846a8e153259e35c43e6163fa5e688ce095968f3804cef7c5b2a0363c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "bf191ad50f19c98e87b3d8968530ab8e208c1cf1e529ff093a6d0dbd6809f3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28e5b899b9f501850d0c85a6bc59de2d7b3fe550849dbdc513897615bdc314d"
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