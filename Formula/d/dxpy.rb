class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackagesd378beb59a5be6be5014d53eb794aa0e73c60e857ab501c4186174853823670cdxpy-0.382.0.tar.gz"
  sha256 "c8427fdc2d293622e2fa250afe6e51fc85a21c5abed697be863eb7a644c502e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "785853ce0a3fdd0d5b781e66cc0992cc74a89525e21bedfeb039bceb47345bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f39a4c7c04e08f2c3296f120fcad75ae4cc6f4ef74c888aebafaf5c587bc225"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4437ddf66ed4bcb98c250287998354a02937ffcf653d15d77f82069b631fac7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "478a1becd0b8324b07c30c80d63bb1efff46edfbd4d8dc339f9bfac47a55f52a"
    sha256 cellar: :any_skip_relocation, sonoma:         "461551abe96cb1a3a9c51807907bb172904c7e6f4cff36fb223c7243609ce1b4"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f479080c81433d257e7272ac1e91328b76d458bddceb5c71e3ba78775fbb64"
    sha256 cellar: :any_skip_relocation, monterey:       "1359527d78b5c90e9852e8fceaa298e0abc321343813a253ecc467710728e93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29186d1cd3e58909e64c1f5aae175f2a2506e932fdebdf1cefbbcd0e2e1bebfe"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
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