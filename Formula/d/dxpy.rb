class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/7d/6a/24de43eace08ff1512c658591466115949ae1bd8fed22e841f6e12f405de/dxpy-0.365.0.tar.gz"
  sha256 "234efe289c71da5069cb7e42f569c9dbff922e270267365d8b36798fd541240c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c2affb85d71e96d8d111c9ce4d7ef4eb5831de5983c4884b10d01b7f59512d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f5526520387cd1cf2fe4636340a8248716d9093cc7464cce9f16edc6f67c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61920a47c79946b59b8e820a8efa185d809d068c5b363e55cc8e20e2745a9d2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e21878d045bbf8bdc25542b9af90327c862c3fe6d296f3ce63af42e69413b9fd"
    sha256 cellar: :any_skip_relocation, ventura:        "4342cfdbaefa523854739956ca2954f11abacaafd128db8b4401e4c4241c9c1b"
    sha256 cellar: :any_skip_relocation, monterey:       "da281f655c14692a7e811c8ee63453cbee83dd905e67aeebb27a1585bd65fd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6201b8f816ef442ccd77074960052d57f0740129cee50224060732e3fe114c42"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python-websocket-client"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end