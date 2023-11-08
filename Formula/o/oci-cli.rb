class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://files.pythonhosted.org/packages/07/b3/1a02a8957d41ba01e046e7eae45c197ba952094a9429c93f9b771873a6e8/oci-cli-3.36.1.tar.gz"
  sha256 "9114c16f6cdf5d387571437fd120281f86f5b98cc49107990732b94a2c9e3d7c"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88cc5100add92ee4bac7242312281de2ef6d1a23d73bff3b7b95c04170d6ecf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3015bdd87fadee78b7d17b9dabff67006ae81121a3e7d16d5ca6662c85d28174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea958358d9ffa02bb6988d5f91fc06232b9cc7156cb5423cb1116945c5811e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "10ece5ddeb020cdf401499e5f04b3fbfbdad893706579ba53b8df5813d9a2e46"
    sha256 cellar: :any_skip_relocation, ventura:        "f2b4864c4cd305e2f814de826a54339dfd8f85957b03cf14d2c611cdd68a4ab8"
    sha256 cellar: :any_skip_relocation, monterey:       "15f38925c966355f3940783e6dbcf3d74319af9f73452565f39ffa0aaf370e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac47556eac80cbf4857400bd2ecd85249e3135e0b3ed3e8c44a6f9d835eb6256"
  end

  depends_on "cffi"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "circuitbreaker" do
    url "https://files.pythonhosted.org/packages/92/ec/7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8/circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https://files.pythonhosted.org/packages/06/d8/7397cb9fd7cf7fd5e44a1d5b1051af5e8270cca5352cb6072b35758a0b29/oci-2.115.1.tar.gz"
    sha256 "0afdd08eb611616910b012ae8044f5be28565a8c988f82583fc1871cbc09988f"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/a6/ad/428bc4ff924e66365c96994873e09a17bb5e8a1228be6e8d185bc2a11de9/wcwidth-0.2.9.tar.gz"
    sha256 "a675d1a4a2d24ef67096a04b85b02deeecd8e226f57b5e3a72dbb9ed99d27da8"
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