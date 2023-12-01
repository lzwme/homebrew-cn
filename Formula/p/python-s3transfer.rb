class PythonS3transfer < Formula
  desc "Amazon S3 Transfer Manager for Python"
  homepage "https://github.com/boto/s3transfer"
  url "https://files.pythonhosted.org/packages/5f/cc/7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988/s3transfer-0.8.2.tar.gz"
  sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "201b464ace00b9800ad35d4d3e98484e43e031cb6d0c754df5329d10d6deefd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347955d1fdbf17142d7d223492e865f6a1d7a831abb8aa54935bbcb7f18f9ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53aa3393f171a5a73910f669fd77f279d68de70b30d5f36380446e353872e7d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "463b9e054a00b9180776a570efe571d022924b1245eb2382d026d10bb830885d"
    sha256 cellar: :any_skip_relocation, ventura:        "0822b0452697de6e27171475223c5eead6bc4418fc7469b20bc344e27fcf43af"
    sha256 cellar: :any_skip_relocation, monterey:       "58141c295d0a5eccfbec2365d5d43d0cb846b96b3eca7e97f75d676f7c6fc02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04c08f56ba546997821a1692aa32f6f9292aa3a3a1bbde9649dcef043d37407"
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