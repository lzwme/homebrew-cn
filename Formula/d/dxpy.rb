class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackagesd47a67d2f81995098180752d328697bbceab959d8bac1c482400d0b901bf19b0dxpy-0.369.0.tar.gz"
  sha256 "dc2f58723d70c6d02155c08d4ac65f41f63aeb05000e4782940d2196b05a962b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e28a877690c8c95b9ba9f3b611671ba8cd142fc13b850c132fe75fd5048197c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2f3b2d44ae9eb0856bb865eed76bef297b9df79e0f92e1dffc713528a241c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fe46a40dd08e146619039d203365669e8766207f99b384e52160a559f6b48e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b32b70bfeb6b33b8e54c25a1acc5e4751715bb1535ef6e8fe0154a61abce28"
    sha256 cellar: :any_skip_relocation, ventura:        "669f1fe4a955925098b5d41ea99e4edf8504f6be59baee63268e3fec1d3ed2cd"
    sha256 cellar: :any_skip_relocation, monterey:       "8ccd314d9648405e739fa2719123fc3d63584a04ad3a2211d6811bc284675ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f0aae89346df7a89e6f5f4c2b142b1a3c058b080880da57cf829ae061243e7"
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

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages71dae94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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
    assert_match dxenv, shell_output("#{bin}dx env")
  end
end