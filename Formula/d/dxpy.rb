class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages311e1829a6f87458a719d471c1bf49d73c024240da81b4993a153008a2d43768dxpy-0.379.0.tar.gz"
  sha256 "09cf1e418be0fc91dd23ee916e83eacd1f5f3baa8972484f713e1cd4ed081ff1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3e0266f8c0ed37c8459d56f7522bf115d00fdc752b90d4b448505b9658e4a41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd10fd0a2deb13ea5f034c6f2c164e766b7ed24194b4d55ecf8b22bc41224efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b0109233db252471e0a93be88199120fadd99f09395149193b540cdd30af59"
    sha256 cellar: :any_skip_relocation, sonoma:         "055eb4188d5525eaaa75480e18126c624db5849c4b02febf12ebe1b7ce1bc614"
    sha256 cellar: :any_skip_relocation, ventura:        "d6785cd2db1ebb47960bffae3d63c673760031dc42f35bad48af4f2b4e81d532"
    sha256 cellar: :any_skip_relocation, monterey:       "774d32251fd7b0dfdec7de1256f6d706d3d1612a95e85512001a12fa83f15879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba506e01fd876f26989e479140008b7bd922f218144fd57c63a5e54355a14e47"
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