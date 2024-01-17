class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages8162b28561bafcebed3d79614fa0c044d4df6b14a87daa79c4ea0468900c7fa3dxpy-0.368.1.tar.gz"
  sha256 "e8fd366edfbe7c9ffd86be14e89d1a0086843442807bea3c404146ca7e96de62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f111c08362a8a8c0593b8e618840d82ad48561eb18f724178488d3862d58969f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2385d7891f39896eebd79d653f39a04a48d2d64faffd7f8b07b12a592b4eace7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf926db1a562e59a2bb912ec522165ff4b6ce242bd1d1c1328e76cf39382223"
    sha256 cellar: :any_skip_relocation, sonoma:         "1100fa6ca00d4a0c91964f31ec62a065ff60f8bedb3ece8425a8825bc7a6d0ac"
    sha256 cellar: :any_skip_relocation, ventura:        "67ded1129c3f43676b26d81d5d2ace2fa3fdd2a83c7822d11702acad5b58c310"
    sha256 cellar: :any_skip_relocation, monterey:       "dba178b7819fe54ff075c348631df50401ef5806ecb2bc1104c47849b31b5221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a153e1dec2c437ebd569821703f9404bcf96487e41558ea80bb2651c8a1d84b6"
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
    url "https:files.pythonhosted.orgpackagesd491c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28certifi-2023.11.17.tar.gz"
    sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
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