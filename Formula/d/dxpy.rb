class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/5e/0c/09aadaebd7676909ea1aa43982b74536f2d27a852956ef6443b6bae4ab09/dxpy-0.366.0.tar.gz"
  sha256 "4f00cc2611d8def8ffc0a996a53e8019fcdc658f827ea9cf56999be7d334ed32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b5a55a5d8e14244b9f2aeaa91fc1e4f26c6c0dc7440f9c6252e5fc956644249"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd63103e839bdb696f7f53fe8313cfa449bbef33ad2356cdbe77884cd6908c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097690dd62af5302c362ad72600ae2fbf11cf337614e6b6c9340777eb267b6e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0df5dd327130953d7763a90d4ad0ac075268d92e2081d781733ef2bcfa5afe5c"
    sha256 cellar: :any_skip_relocation, ventura:        "c2beef9dee96adff83fffb0b1bde05b5bfbda6f7e83b45dc33d47f9e7ac75ae3"
    sha256 cellar: :any_skip_relocation, monterey:       "6d59b5fd492b226c3e84671de4cafa8267331bdb247de0615138124cdb550f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e0468ce441a172b16247d3ccfbddb82e3538242685868a6b46023c91f45d1a"
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
    url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
    sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
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
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end