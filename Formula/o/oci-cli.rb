class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/e1/18/9248a5a9d397dc63cde3248c7eda1cf6fcc4da04e61f221b83ad5c862eaf/oci-cli-3.33.0.tar.gz"
  sha256 "f2eb1042a9fae425e3047bd25d32c3881e34bb0f7480d74dc6e7bd2f3fd20c7e"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fec459c67f886685f342b339ee9bd52449154dd8b6a9c5826352fa3d1b7513f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f12617bf083347daa05712bbc55850fe7ccfc9bc680c62ad2ed7c88a76bd4af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e688ed8999dea80efc4baa5462d184663e39dcfd117e69bff5d9ae245f487b2c"
    sha256 cellar: :any_skip_relocation, ventura:        "6539296ccf2346a5f78fe8686958bde4973f5f0c27979ce10c6d6568e88e1a4f"
    sha256 cellar: :any_skip_relocation, monterey:       "5993f4142c8e40c2cd8a4331761655e43e0dfae7358feb09036762116b375370"
    sha256 cellar: :any_skip_relocation, big_sur:        "7384544f8026e2b011e37b29e2fabfa39e1acc897b4f5a3d6b78879fb6969501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cfeb079e8140ff8868704e8e684a7d6b56e465d7b32d9081243ede539166f1"
  end

  depends_on "cffi"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/92/ec/7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8/circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/4f/13/b6de155bd0f59620470d7b35c609f461ff50b2ed6b58e067247c4ae3806b/oci-2.112.0.tar.gz"
    sha256 "ebea8141dce7ff209db51d81cae5dca5128a4ac57adae5cd677e16494997aa05"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    version_out = shell_output("#{bin}/oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}/oci --help")
    assert_match "", shell_output("#{bin}/oci session validate", 1)
  end
end