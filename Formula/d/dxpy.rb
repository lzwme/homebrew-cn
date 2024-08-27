class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages1014eaaa19a8970127db18dfd3c091cd995a5e2adeac2dadcc5d343dceba6867dxpy-0.381.0.tar.gz"
  sha256 "84fea9b33be93b97ce2d92ff0f5b0eaa63920c43776df3cdf0abb099c117c6cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5808c794528c0b8210fcb4a5c5d66cfac3e2c8b032c2c59dd00ca0ed8f385088"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d9e9e81e8b609490df34cc0093e1928201c5ef6a745cdc7fce45bec97d23cfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063acbd4967687e97f2459c0956b79a4d7333c841720166acc1c77f99004749c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1a4cfc884b67789f12255b68e9d1ccb7db5edaae3d15de8619cb412923985ae"
    sha256 cellar: :any_skip_relocation, ventura:        "80cd0997ab4839cfe3ecf3574a9cd540cd2c60134af6239e80a784e30b95c6e4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf1120dba319434a2f23047ebf33d046e8d8def56f6ae2a00264624a4d4a10b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f937ce90c53ccdacb769b8aa551ca679dc55b2d078bc76d4cfa6b093f6cd597"
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