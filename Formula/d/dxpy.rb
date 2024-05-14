class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https:github.comdnanexusdx-toolkit"
  url "https:files.pythonhosted.orgpackages4b4fab3583ecd0e2a567a6461b253790340510817132123fec476710f117fc5edxpy-0.375.1.tar.gz"
  sha256 "7260fe1e79afaa2b8917cde52d03febb0ce7271e361dff8af06980506ef6ebd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f63b7c5db225434ac08087faf6abc98b70b6380b388dbaad37cdae5cb62d6a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8c5cf6bfa472ee4ee6f2390ebd751ad846dc76b9fc4f242b01d61ece26ab354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf4df372ae10cfac9238fbdd174e773ba3a8c6336f6bedbee2822efddc106eaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "3582a2e09208719eaf0314ba40de4107e2737d515ed150b287915d64064c67b5"
    sha256 cellar: :any_skip_relocation, ventura:        "fb105997c493f16316a0a1f7d0b2fba2a5d25496561ae051100ab0c2ee847ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "ff25a3ef1b5a771865033c1ba29e8f00d938cec49b7e1dcd44c4a13f5763913d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcde22ef466b6c39f92dbc4683d685e294791250d75b7f3c59c9790b6eedea91"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7951fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages90c76dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
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
    url "https:files.pythonhosted.orgpackages35d414e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249bwebsocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
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