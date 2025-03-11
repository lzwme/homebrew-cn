class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackagesb769fff81f942f2d8344c6a8a46488508dccb918680fe91c0606b09e3688b0c5dxpy-0.392.0.tar.gz"
  sha256 "a59a3f1a1755420165faae06cbff14e76cf796e77f9d6d45f0668e01dc0b6588"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6c5bac12181a203c2b0652bcf2042cdb67fe48e3982766928a2f23c4fb82e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08da5a73725753d51b8c7d33e0ce1b15bf64ed42a4ccc0f4f3b688106d125b34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e352f6a4431603942ad8ed6a2c16daea641b38b631c0853d12bbbb19a93bfa4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6227f9d2bcf352d0c89384916cdf887520bc0690ea65d721b616bcef2b0dd172"
    sha256 cellar: :any_skip_relocation, ventura:       "eafa3ad03f5e46a3d16c35b207ea999ef1f3c13f4ed1b40ef7f522f7c7a8294f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b1cfb372675cf4ceb5f27342e187fab9fb7e9feecdbd98e7d9739908481c27"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackageseebe29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589argcomplete-3.6.0.tar.gz"
    sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
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