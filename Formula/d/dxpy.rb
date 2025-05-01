class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages6728232465b4bb241c5cd9fb20f8dc66cf469a9bc3757430e58e62897c0ee016dxpy-0.395.0.tar.gz"
  sha256 "efa5d5a3e65eb8de2faa56131f7ace87feab163d0bd67e89401160b8885d2a5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50df7e27ce079a3e670d7b31dd3681eb4baf1e25999c2aa31cfd76f6a7261851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6353d9fcc379bf129f522646a76d9e583da9d52a5e897e05609b651b20019853"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e76c14e87cc78a4e0fd96f0d0e0b41037bf2320a86584229195b2463e230a67f"
    sha256 cellar: :any_skip_relocation, sonoma:        "80676ff89c37ab13c1131b7140b4d0e5a88ee6dbfcea7640e85e653d67c0114f"
    sha256 cellar: :any_skip_relocation, ventura:       "6b1b18f68dd9f6c043591635f55c30e254e68a67ab0f2fdc60dbcc071590220e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9df1c3d7de6190d8016add2863bdf86639d4bd6e31e1495dc2e162041cdd1e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85a5533c2ab1a68f73855abf2ce73de531ff32381ed4fc9827d2797f1ed99ba"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "crc32c" do
    url "https:files.pythonhosted.orgpackages7f4c4e40cc26347ac8254d3f25b9f94710b8e8df24ee4dddc1ba41907a88a94dcrc32c-2.7.1.tar.gz"
    sha256 "f91b144a21eef834d64178e01982bb9179c354b3e9e5f4c803b0e5096384968c"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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