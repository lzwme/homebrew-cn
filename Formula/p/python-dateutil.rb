class PythonDateutil < Formula
  desc "Useful extensions to the standard Python datetime features"
  homepage "https:github.comdateutildateutil"
  url "https:files.pythonhosted.orgpackagesd977bd458a2e387e98f71de86dcc2ca2cab64489736004c80bc12b70da8b5488python-dateutil-2.9.0.tar.gz"
  sha256 "78e73e19c63f5b20ffa567001531680d939dc042bf7850431877645523c66709"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2003c87754e04db1a9fa72148fd3ae10e8c01167472b8c1721d5b029b289c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a5fee86a47d791af5f0a2c3e38f79f7362476c4f678864048a0ebcaee6c00c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b04f10a11573c1014097b7b174aa87069de9b87be768d1523efc01a9496df7ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "b306c1b0c709f9a06eb9915ccd98e8d9be3cc766e101c4142ac74725b54a201c"
    sha256 cellar: :any_skip_relocation, ventura:        "0a6281f3ad3fd1ec74314ea121261578c963145e422c05ca17dfd80aeb578e04"
    sha256 cellar: :any_skip_relocation, monterey:       "f60075b312beaf9d4e5c23a7f8a6689f8ec1df7f03d97c6e3aff867905ac8103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b4a5c21bd430e847dfd3def8edac1581b75e82c103019a54f1d9678a1d9f95"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
      system python_exe, "-c", "import dateutil"
    end
  end
end