class PythonBoto3 < Formula
  desc "AWS SDK for Python"
  homepage "https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/index.html"
  url "https://files.pythonhosted.org/packages/07/2d/6b217bb14849a79d6c419b96518e55252995b9857b1df52b952cbabe066b/boto3-1.29.0.tar.gz"
  sha256 "3e90ea2faa3e9892b9140f857911f9ef0013192a106f50d0ec7b71e8d1afc90a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7e755c9fed1d8202c64b69dfddb30e14c0f37338397d1e57c6b32ab81e46a92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa1aa16213172d9b8856e3abae9e68479592980dabc46c816cf3fd5fea7987dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9816e1200b41235b3977230ba3cdd2eb9d9f274a05f1369239358c2429bba9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8462ec0d480a43a0c9b0cdd94e71d6a7ac277abe609041e8f03922bb669433e"
    sha256 cellar: :any_skip_relocation, ventura:        "23102f55a0f80c66f16eadbd4273bca90fc8a8b0285827893ada459bdcb90d26"
    sha256 cellar: :any_skip_relocation, monterey:       "bba3844b7ba12236b16bc1c3d30309dccce0b31e5c3907c7932b6bdc6bda28ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ae07947aa3db972016221394e1a2b7f78a046951d48cce99c71c48192768c5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"
  depends_on "python-s3transfer"

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
      system python_exe, "-c", "import boto3"
    end
  end
end