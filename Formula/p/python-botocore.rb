class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/0b/bf/356dd9f6b6587eea3070c4174a4e05311b5772fa2ee8676aa3b14b8d5b46/botocore-1.33.4.tar.gz"
  sha256 "872decbc760c3b2942477cda905d4443bd8a97511dcee3e9ca09eeb9299ad5e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4c9f1936443173a75023560edd71b8f567bb9fb83b544a13b9fb38347f27b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "709270e8cf9f56670d6c1ec4d6c152bc8adca63e4cda449284f4cbe60fb96f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a8ae3cfeef0862490639b2ee24e068e3fe79fbc4bf1c763260bfbce857c824"
    sha256 cellar: :any_skip_relocation, sonoma:         "e666952e88937437c997b5498abf498120674d0ee6b7299d578f275aaebd9d15"
    sha256 cellar: :any_skip_relocation, ventura:        "6419284c779c9e41819205811947067ca1ead15ce61ad85eab48f059992da2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf811e7381dcf166d5a1a29c8cb14bc1e244ddc3c0aceba64348eb0f62c85ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0638d2c50d8f4248ff70a516081b73c8377eef0980cdcb321b9fb5d24e8ed1ef"
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