class PythonS3transfer < Formula
  desc "Amazon S3 Transfer Manager for Python"
  homepage "https:github.combotos3transfer"
  url "https:files.pythonhosted.orgpackagese445973579466ff4869756f2ba5cc31773d5fc9db67085f722a6b38b8558d70ds3transfer-0.9.0.tar.gz"
  sha256 "9e1b186ec8bb5907a1e82b51237091889a9973a2bb799a924bcd9f301ff79d3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3306c09d18760147103533e57f5f311deabaf98cc3706102ba985239db0d310d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071bc0413bd3ff7b1aeb620bf8a4f0d376bc6532f8c29c2b9551344ed0b27143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a8f57dcc7e7479df80bb5c77549f7370c094cdf664fda6c7baa815fd8ccba3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a10eb04bb7a03df07ebfa91ccb7bf357e2bc10eaa9ae22bb176e0e9af02e3e08"
    sha256 cellar: :any_skip_relocation, ventura:        "70839a6be08dc6038764572fada17447f6cf8e991e3400418a58e6e48d04c43e"
    sha256 cellar: :any_skip_relocation, monterey:       "a148453c5ed35abea7c4b1bfd5aa1b1238ab1ac9a02e3b14ba040ff7be87c904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd0d1d0c0fe3a4f94dcf4e3c3256e438a58cfbb76f2884503486fea5c8638f17"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
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
      system python_exe, "-c", "from s3transfer.manager import TransferManager"
    end
  end
end