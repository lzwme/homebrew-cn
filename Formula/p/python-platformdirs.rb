class PythonPlatformdirs < Formula
  desc "Python package for determining appropriate platform-specific dirs"
  homepage "https://platformdirs.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
  sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9980d47079d9dac643eeec2e6e97fefdbc29f0b55d0d46873de5abc1d255dcbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed5e11f84d6343a5552a951b81f0a2b66ddaefa9348c975110214a2a41912e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "262b63f634fd9e846b969ed279cfba9423b5e845b96fb25e423448e102a0e342"
    sha256 cellar: :any_skip_relocation, sonoma:         "80bac7d8f72c240dfaa00872187dde73650f80d796c74f97345ed9da948b5f39"
    sha256 cellar: :any_skip_relocation, ventura:        "4e290e7be5c7e17b0994679f39b31b2f833ace7b6497d172d44a80e0259e5a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "043fa9a5601f63d26b2aa530a188148272546503734b95485585154953eb1532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11bed84e92e51051b91590e5aed9c6a96337357ab9de0e28be0d9f9367fb6d29"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      system python_exe, "-c", "import platformdirs"
    end
  end
end