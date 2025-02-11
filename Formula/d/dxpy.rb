class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages3917e55b1ee5fc501969d027159eddad0f0ac7d01ad6a9ef57f7975fa4465ff2dxpy-0.389.0.tar.gz"
  sha256 "fdba8390f27f915e517da5bae8a9b5cd2b3e144af84979bf99454fca30b7f7b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe837029ec4753dd453bd2b954ec9f3b2779fe69cfad6d1c786bc762804fa0e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff3abcfd175d1fbf92d529130783473843d59bdf5b480df0f7102b6688b7cc7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b2125721882ae616545dd4ee6ed52ba443c86a97700d3a2e77ef72d5d5f69da"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb5636c3d5addd8b0305a6242dfddd89d8f6180f1b3673f3bfe128a555888fb"
    sha256 cellar: :any_skip_relocation, ventura:       "3058b9b21d687bf16a27916e10a703e8682231314840470267363702c2f4595f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651fcc3ba8e78562ec7abde66bf9e082a59e524f291880131d874f6010489665"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0cbe6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages1f5a07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cbpsutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
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