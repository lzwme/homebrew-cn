class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages5a4b84f73f96807c37b6a1f182c43c1f92e5c6c2a0a4213e9e77b4fd8e6e1a95dxpy-0.391.0.tar.gz"
  sha256 "6868a3ebaf4cae4a8902bbc2f8eaa6f479664a0cadcdace854837bf07479f172"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51798b07ec45ea207df688748b10b2aee4854339f69d0d4e06132a2998a7f986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37253ac8668edf34183f16283f51e1cc1366dbea701dba5f842747d199996aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25e278739a1f43f3f5ba73d10e26ce004e9a72d7356d7d98e5b09b03cfd218d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0649cc0d8587f1403b2b779b6ec6f948b6c9a6dc048821ce6858d7ac53776403"
    sha256 cellar: :any_skip_relocation, ventura:       "48e1063810c010456463b4f9d96b1a0670a025752b5b8eb23c584bb318db9ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3784bdc805aadee93bfb3288451c60596d50fbb5dc5323012f03bb72dfc63d9c"
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