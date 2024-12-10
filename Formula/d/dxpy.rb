class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages9034f6361dc1c72a5a6ba83f3c65ddceed00a986bd92bf7add1603c3d76de3b9dxpy-0.386.0.tar.gz"
  sha256 "9568441861351bd590a2612c34137b266f63df2fab7ee0a88d566a4ee85c6128"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d757784a33410d4f12c923987f9b457fb8a0d85af60182425377b4e943b2ed49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d27c901e892c6e066ed4839bcf0892f1244be5496cbca361dd8d991aad9750c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b38310d7bd18f05762f0a4cf72bbe1a20df38da940aa67d692991f44e599bc8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44ce9dce51aa4f19c4ed09305081bb45d9e0bbdf82395c9de6d1010e3d3b472"
    sha256 cellar: :any_skip_relocation, ventura:       "651d9953f5801d584ed4ef5565fcf71a998b90371244ac4e7ed994da93ed8c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070e1b72d8a224473e290bb1d2042fe57d9608e25d0ee08e64964e20e76b8cdd"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages26102a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
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