class PythonS3transfer < Formula
  desc "Amazon S3 Transfer Manager for Python"
  homepage "https://github.com/boto/s3transfer"
  url "https://files.pythonhosted.org/packages/48/62/53056e8a931a004b9a958c7ca709350a94e212ebcadfc9914a2a8bfaa4ec/s3transfer-0.8.0.tar.gz"
  sha256 "e8d6bd52ffd99841e3a57b34370a54841f12d3aab072af862cdcc50955288002"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "225de50284ae6aad845034d1ff23a3cd6484e3c5fceaead49eab1dfe58f34493"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ee87dc77ab26297aad65bd080ea060009f1d7d3dad83d644f271d1899d11a3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42d0ac27bcd78f9bcd0d795588c258c7c2ccd2571445e240944ecf150122c3f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aa70bab5d9fa627303286a66e90017b9b1f755137fd35b0766e97ea148815d7"
    sha256 cellar: :any_skip_relocation, ventura:        "3753ccb06cf95ee9a840623a0493f4ffd5a15bb5fed47b8fbc15afdf9d0d612a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb545654854709af83e145154d0a6372197f1224a5db2d96afb6a8c15e967dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bfc6862c1b8f6387a30ce67a009d9c5f6a8cc4d20bea5f540abcc9e995001cd"
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
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from s3transfer.manager import TransferManager"
    end
  end
end