class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackagesbb7ab076c1fff212bc51fab34e4d25e1e6f3dfc7412a6dd8067163f6c3750b1ddxpy-0.393.0.tar.gz"
  sha256 "35a3d3c84831ae24b09459f7a2025ebccdc48b130170435248bdc9bccaa05e7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f266aa6275112be56f9c8926dd255dd995f4ed752f7a18becdc1badb8937b644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1def02be31edfb12989798699442c1d2306ab60d6b77d73fe9887325a6f1847"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f4b120fccc19648caae15575732ead70951c52d2567e57d62ee33e5d85ded9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae90c8ab991e5f27bf9355f02c9993d4e8443e8657e0447ff5358d6eeed9c901"
    sha256 cellar: :any_skip_relocation, ventura:       "445de1f419ef92c3ba500d6244f0c0e9cf4a15b77362c41a72b78c3f5b3e3ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf148d66a785f36a8da0b2f3b44bd413d3c680d1f97110254bf496edecf72af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d40f7b40466f85811121fe8cc34aa026dbfb4365c52396a322a09d0d2e567d"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0a35aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39bargcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
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