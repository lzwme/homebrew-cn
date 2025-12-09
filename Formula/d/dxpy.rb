class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/79/8e/e26977a5f918cfa63fdc3364ca2b2784a6a3b4824d0e1e48e43236e02291/dxpy-0.401.0.tar.gz"
  sha256 "1f8c09aa191941210c4371fdad4566ff9c9a689b0f72ca9a09a9a233207e880b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4049f6c13b648465cb6f983683c1121d2734ff878c752de6fe64cd1273706bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8995d33a4f7cfee1ca0299641eb476c6b66781c70932a95073821b2d88c3ae43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6910305b7fe97b813990b1bd88990c78a4146a226fc8815adc71ca6ab543c2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff8901c67f69940884267b93a404bd152c0f1be0024ebf2f28c8afcc0414c09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa2513a2aa191126016f4e4e2f98e62e9907b9f26d6e8686f0ab012e198ac1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bb51069fde0160143d86cb3d15d1881ddcb426f415d87b6a924c47e971b1c3f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  pypi_packages exclude_packages: ["cryptography", "certifi"]

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
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
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end