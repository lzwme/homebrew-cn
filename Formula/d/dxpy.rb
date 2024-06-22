class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages0235cd50421a8cb3b207650a77ca711cd411b45f48b6f619332e6ec0fd0f4d4edxpy-0.378.0.tar.gz"
  sha256 "fe82611e622f8a5016cee3821f337a0e20808c4a9d70da93dc900574fee2897e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0ca6462e4c859fd7d9df32084d463ae24f7014cd939870d70f82a93f85f85c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad9a488880e3ba07c5515712f544d421e19b4223373c8cd42e5f2412c1d57b71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642b363920445dfc4b68f1b70c477108679a52f22460e47ac34b2279b6e5b702"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ff261fb35f489e049de9488079842bf6b230ae6ebe380b9bab5de508d71f427"
    sha256 cellar: :any_skip_relocation, ventura:        "caad02918dfe26dc7fa1538e76da947d9b6702b097432efdbc1c0571fc6f7315"
    sha256 cellar: :any_skip_relocation, monterey:       "11f14280cb9f6b242836e45b3426fad679a1b9cb57589cdc0b9b97bb2226776c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "164cc5157123016e93cebad8f81d712e80fee56a8e04a6fd70abc2786f53d9a3"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages18c78c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackages20072a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def install
    virtualenv_install_with_resources
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