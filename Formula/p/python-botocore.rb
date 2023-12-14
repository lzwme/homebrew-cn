class PythonBotocore < Formula
  desc "Low-level, data-driven core of boto 3"
  homepage "https://botocore.amazonaws.com/v1/documentation/api/latest/index.html"
  url "https://files.pythonhosted.org/packages/f4/18/daf6799ca51e8ab2d5fe10e1e1bd05e156a14228ac1bf9f402e0599892ee/botocore-1.33.13.tar.gz"
  sha256 "fb577f4cb175605527458b04571451db1bd1a2036976b626206036acd4496617"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4af4c4dec6cc6192deeaaa3752b0dc8258d7ea0933264dbdd218be204f5aa59b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37cf6a89c235c5b8f37e1aad3d623c3ce337e7e34df1f84c5f0c4b52ddcf7624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "635669ea5073c0657cc30982c9ec1e6f13dd0c0f7af65e98d72fadfc76236665"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5cc023380a5faac79d8201ed7e6387f8426831a656436a334e59206e47ed13"
    sha256 cellar: :any_skip_relocation, ventura:        "660e38bc7dd76d9441d08974084f52b95369dea22052d77cace4c0dc0aec18b3"
    sha256 cellar: :any_skip_relocation, monterey:       "0dffa994260700928866c5f39eab2c585edddcfe97429e0ccd20f89f99eb6e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b20279d050ba14840cad7ceaa50dd37b1466c17f02426b9f7200da8bd3c8325"
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